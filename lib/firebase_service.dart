import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Stream<Map<String, double>> getSensorStream() {
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      final temperature = data?['DHT22']?['Temperature'] ?? 0.0;
      final humidity = data?['DHT22']?['Humidity'] ?? 0.0;
      final coPPM = data?['MQ2']?['CO'] ?? 0.0;

      return {
        'temperature': (temperature is num) ? temperature.toDouble() : 0.0,
        'humidity': (humidity is num) ? humidity.toDouble() : 0.0,
        'co_ppm': (coPPM is num) ? coPPM.toDouble() : 0.0,
      };
    });
  }

  Stream<String> getMQ2AlertStream() {
    return _dbRef.child('MQ2/Alert').onValue.map((event) {
      final data = event.snapshot.value;
      return data != null ? data.toString() : "SAFE";
    });
  }

// This listens to the CO ppm value in Firebase
  Stream<double> getCOStream() {
    return _dbRef.child('MQ2').child('CO').onValue.map((event) {
      final value = event.snapshot.value;
      if (value != null) {
        return double.tryParse(value.toString()) ?? 0.0;
      } else {
        return 0.0;
      }
    });
  }

  Stream<List<Map<String, dynamic>>> getMQ2HistoryStream() {
    return _dbRef.child("MQ2/Readings").onValue.map((event) {
      final readings = <Map<String, dynamic>>[];

      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      data?.forEach((key, value) {
        final entry = value as Map<dynamic, dynamic>;
        readings.add({
          'timestamp': key,
          'value': entry['value'] ?? 0.0,
        });
      });

      readings.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      return readings;
    });
  }
}
