import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'dart:math';

class GasSensorPage extends StatefulWidget {
  const GasSensorPage({Key? key}) : super(key: key);

  @override
  State<GasSensorPage> createState() => _GasSensorPageState();
}

class _GasSensorPageState extends State<GasSensorPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQ2 Gas Sensor Data'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        color: Colors.lightGreen[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Real-Time Gas Sensor Readings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<Map<dynamic, dynamic>>(
                stream: _firebaseService.getGasSensorStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }
                  final dataMap = snapshot.data!;
                  final entries = dataMap.entries.toList();

                  // Sort descending by timestamp
                  entries.sort((a, b) {
                    final t1 = a.value['timestamp'] ?? '';
                    final t2 = b.value['timestamp'] ?? '';
                    return t2.compareTo(t1);
                  });

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final item = entries[index].value;
                      final gas = item['gasPPM'] ?? 0;
                      final time = item['timestamp'] ?? '';
                      return ListTile(
                        title: Text("Gas: $gas PPM"),
                        subtitle: Text(time),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
              ),
              onPressed: _saveFakeGasReading,
              child: const Text("Save Random Gas Reading"),
            ),
          ],
        ),
      ),
    );
  }

  /// Simulates a random gas reading and saves it
  Future<void> _saveFakeGasReading() async {
    final rand = Random();
    final fakeGas = 300 + rand.nextDouble() * 200; // e.g. 300-500 PPM

    // Save to Firebase
    await _firebaseService.saveGasReading(fakeGas);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Random gas reading saved!")),
    );
  }
}
