import 'dart:async';
import 'package:flutter/material.dart';
import 'package:environment_sensors/environment_sensors.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _lightAvailable = false;
  final environmentSensors = EnvironmentSensors();

  Future<bool> provjeriStatus() async{
    PermissionStatus status;
    status = await Permission.sensors.request();
    if(status.isGranted){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> initPlatformState() async {
    bool lightAvailable;
    lightAvailable = await environmentSensors.getSensorAvailable(SensorType.Light);

    bool istina=await provjeriStatus();
    if (istina) {
      setState(() {
        _lightAvailable = lightAvailable;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Senzori okoline'),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (_lightAvailable)
                ? StreamBuilder<double>(
                stream: environmentSensors.light,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Text(
                      'Trenutni intenzitet svijetla(Lux): ${snapshot.data!.toStringAsFixed(2)}');
                })
                : Text('Nije pronaden senzor svjetlosti!'),

          ])
      ),
    );
  }
}