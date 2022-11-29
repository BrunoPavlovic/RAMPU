import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primjer akcelometra, žiroskopa i magnetometra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Primjer akcelometra, žiroskopa i magnetometra'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Future<bool> provjeriStatus() async{
    PermissionStatus status;
    status = await Permission.sensors.request();
    if(status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> listener() async{
    bool istina = await provjeriStatus();
    if(istina){
      _streamSubscriptions.add(
        gyroscopeEvents.listen(
              (GyroscopeEvent event) {
            setState(() {
              _gyroscopeValues = <double>[event.x, event.y, event.z];
            });
          },
        ),
      );
      _streamSubscriptions.add(
        userAccelerometerEvents.listen(
              (UserAccelerometerEvent event) {
            setState(() {
              _userAccelerometerValues = <double>[event.x, event.y, event.z];
            });
          },
        ),
      );
      _streamSubscriptions.add(
        magnetometerEvents.listen(
              (MagnetometerEvent event) {
            setState(() {
              _magnetometerValues = <double>[event.x, event.y, event.z];
            });
          },
        ),
      );
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
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gyroscope = _gyroscopeValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer = _magnetometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Akcelerometar, žiroskop i magnetometar'),
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
        <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Akcelerometar: $userAccelerometer'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Žiroskop: $gyroscope'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Magnetometar: $magnetometer'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}