import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'graph_page.dart';
import 'gas_sensor_page.dart';
// import 'gas_sensor_local_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  double temperature = 0.0;
  double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen for DHT11 data
    _firebaseService.getSensorStream().listen((data) {
      setState(() {
        temperature = data['temperature']!;
        humidity = data['humidity']!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DHT11 Sensor Data'),
        backgroundColor: Colors.lightGreen,
      ),

      // Drawer for navigation
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightGreen),
              child: const Center(
                child: Text(
                  'Sensor Navigation',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.device_thermostat),
              title: const Text('DHT11 Graph'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GraphPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.gas_meter),
              title: const Text('MQ2 Gas Sensor'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GasSensorPage()),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.storage),
            //   title: const Text('Local Gas Data'),
            //   onTap: () {
            //     Navigator.pop(context); // Close the drawer
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const GasSensorLocalPage()),
            //     );
            //   },
            // ),
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
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GraphPage()),
                );
              },
              child: const Text(
                'View Graph',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GasSensorPage()),
                );
              },
              child: const Text(
                'MQ2 Gas Sensor',
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
