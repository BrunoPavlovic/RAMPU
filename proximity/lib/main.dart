import 'package:flutter/material.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _isNear="Nije blizu";
  String blizu="Blizu";
  String nije="Nije blizu";
  late StreamSubscription<dynamic> _streamSubscription;

  Future<bool> provjeriStatus() async{
    PermissionStatus status;
    status = await Permission.sensors.request();
    if(status.isGranted) {
      return true;
    } else {
      return false;
    }
  }


  Future<void> listener() async {
    FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
    };
    bool istina = await provjeriStatus();
    if (istina) {
      _streamSubscription = ProximitySensor.events.listen((int event) {
        setState(() {
          _isNear = (event > 0) ? blizu : nije;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listener();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Proximity'),
        ),
        body: Center(
          child: Text('Proximity:  $_isNear'),
        ),
      ),
    );
  }
}