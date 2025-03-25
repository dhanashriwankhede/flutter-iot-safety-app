import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MQ2Page extends StatefulWidget {
  const MQ2Page({Key? key}) : super(key: key);

  @override
  _MQ2PageState createState() => _MQ2PageState();
}

class _MQ2PageState extends State<MQ2Page> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('MQ2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQ2 Gas Sensor Readings'),
        backgroundColor: Colors.green.shade700,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No MQ2 readings yet...'));
          }

          final readings =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final gasData = readings.entries.map((entry) {
            return {
              'gasPPM': entry.value['gasPPM'] ?? 0.0,
              'timestamp': entry.value['timestamp'] ?? '',
            };
          }).toList();

          return ListView.builder(
            itemCount: gasData.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Gas PPM: ${gasData[index]['gasPPM']}'),
                  subtitle: Text('Time: ${gasData[index]['timestamp']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
