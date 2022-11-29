import 'package:flutter/material.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BarometerValue _currentPressure = BarometerValue(0.0);

  Future<bool> provjeriStatus() async{
    PermissionStatus status;
    status=await Permission.sensors.request();
    if(status.isGranted){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> listener()async{
    bool istina=await provjeriStatus();
    if(istina){
      FlutterBarometer.currentPressureEvent.listen((event) {
        setState(() {
          _currentPressure = event;
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barometar'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(_currentPressure.hectpascal * 1000).round() / 1000} hPa',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}