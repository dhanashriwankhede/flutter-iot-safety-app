import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Stream DHT11 data from "DHT11" node
  Stream<Map<String, double>> getSensorStream() {
    return _dbRef.child('DHT11').onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final temp = (data['Temperature'] ?? 0).toDouble();
        final hum = (data['Humidity'] ?? 0).toDouble();
        return {'temperature': temp, 'humidity': hum};
      }
      return {'temperature': 0.0, 'humidity': 0.0};
    });
  }

  /// Save gas sensor data to "MQ2" node
  Future<void> saveGasReading(double gasPPM) async {
    String? newKey = _dbRef.child('MQ2').push().key;
    await _dbRef.child('MQ2/$newKey').set({
      'gasPPM': gasPPM,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Stream gas sensor data from "MQ2" node
  Stream<Map<dynamic, dynamic>> getGasSensorStream() {
    return _dbRef.child('MQ2').onValue.map((event) {
      if (event.snapshot.value == null) return {};
      return event.snapshot.value as Map<dynamic, dynamic>;
    });
  }
}
