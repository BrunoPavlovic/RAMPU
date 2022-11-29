import 'package:flutter/material.dart';

class SecretPage extends StatelessWidget {
  const SecretPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Druga stranica'),
      ),
      body: const Center(
        child: Text(
          'Uspješno ste se identificirali',
          style: TextStyle(fontSize: 27),
        ),
      ),
    );
  }
}