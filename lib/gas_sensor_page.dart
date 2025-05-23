import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GasSensorPage extends StatefulWidget {
  const GasSensorPage({Key? key}) : super(key: key);

  @override
  State<GasSensorPage> createState() => _GasSensorPageState();
}

class _GasSensorPageState extends State<GasSensorPage> {
  double coPPM = 0.0;
  String alertStatus = "SAFE";

  final DatabaseReference _coRef = FirebaseDatabase.instance.ref('MQ2/CO');
  final DatabaseReference _alertRef =
      FirebaseDatabase.instance.ref('MQ2/Alert');

  @override
  void initState() {
    super.initState();

    _coRef.onValue.listen((event) {
      setState(() {
        coPPM = (event.snapshot.value as num?)?.toDouble() ?? 0.0;
      });
    });

    _alertRef.onValue.listen((event) {
      setState(() {
        alertStatus = event.snapshot.value?.toString() ?? "SAFE";
      });

      if (alertStatus == "HIGH CO LEVEL") {
        _showAlertDialog();
      }
    });
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🚨 Alert"),
        content: const Text("High Carbon Monoxide Level Detected!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MQ2 Gas Sensor"),
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.orange[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CO Level (PPM)",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "${coPPM.toStringAsFixed(2)} PPM",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color:
                    alertStatus == "HIGH CO LEVEL" ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Status: $alertStatus",
              style: TextStyle(
                fontSize: 18,
                color: alertStatus == "HIGH CO LEVEL"
                    ? Colors.red
                    : Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Icon(
              Icons.warning,
              color: alertStatus == "HIGH CO LEVEL" ? Colors.red : Colors.grey,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
