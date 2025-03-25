import 'package:flutter/material.dart';

class GasSensorLocalPage extends StatelessWidget {
  const GasSensorLocalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Gas Sensor Data"),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text("Local data storage disabled"),
      ),
    );
  }
}
