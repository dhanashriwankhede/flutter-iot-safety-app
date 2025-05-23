import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'graph_page.dart';
import 'gas_sensor_page.dart';
import 'mq2_graph_page.dart'; // New MQ2 graph

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  double temperature = 0.0;
  double humidity = 0.0;
  double coPPM = 0.0;

  @override
  void initState() {
    super.initState();

    // Listen for DHT22 sensor data
    _firebaseService.getSensorStream().listen((data) {
      setState(() {
        temperature = data['temperature'] ?? 0.0;
        humidity = data['humidity'] ?? 0.0;
      });
    });

    // Listen for CO PPM value (from MQ2)
    _firebaseService.getCOStream().listen((ppmValue) {
      setState(() {
        coPPM = ppmValue ?? 0.0;
      });
    });

    // Listen for MQ2 Alert
    _firebaseService.getMQ2AlertStream().listen((alert) {
      if (alert == "HIGH CO LEVEL") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⚠️ High CO Level Detected!"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Dashboard'),
        backgroundColor: Colors.lightGreen,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightGreen),
              child: Center(
                child: Text(
                  'Sensor Navigation',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.device_thermostat),
              title: const Text('DHT22 Graph'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GraphPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.gas_meter),
              title: const Text('MQ2 Gas Sensor Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GasSensorPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('MQ2 Graph'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MQ2GraphPage()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.lightGreen[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Real-Time Readings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            _buildReadingTile('Temperature', '$temperature °C', Colors.red),
            const SizedBox(height: 20),
            _buildReadingTile('Humidity', '$humidity %', Colors.blue),
            const SizedBox(height: 20),
            _buildReadingTile(
              'CO Level',
              '${coPPM.toStringAsFixed(1)} PPM',
              coPPM > 35.0 ? Colors.red : Colors.black,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const GraphPage()));
              },
              child: const Text(
                'View DHT22 Graph',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MQ2GraphPage()));
              },
              child: const Text(
                'View MQ2 Graph',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingTile(String label, String value, Color valueColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
