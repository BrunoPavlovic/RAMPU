import 'secret_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otisak prsta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> provjeriStatus() async{
      PermissionStatus status;
      status = await Permission.sensors.request();
      if(status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
    LocalAuthentication auth = LocalAuthentication();

    Future authenticate() async {
        final bool isBiometricsAvailable = await auth.isDeviceSupported();

        if (!isBiometricsAvailable) return false;

        try {
          return await auth.authenticate(
            localizedReason: 'Skenirajte otisak',
            options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
            ),
          );
        } on PlatformException {
          return;
        }
      }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Senzor otiska prsta'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool istina = await provjeriStatus();
            if (istina) {
              bool isAuthenticated = await authenticate();
              if (isAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SecretPage();
                    },
                  ),
                );
              } else {
                Container();
              }
            }
          },
          child: const Text('Stisni za skeniranje'),
        ),
      ),
    );
  }
}