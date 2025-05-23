import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'firebase_service.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

/// Model for the chart
class SensorData {
  final double timeIndex;
  final double value;
  SensorData(this.timeIndex, this.value);
}

class _GraphPageState extends State<GraphPage> {
  final FirebaseService _firebaseService = FirebaseService();

  List<SensorData> _tempData = [];
  List<SensorData> _humData = [];
  double _timeCounter = 0;

  @override
  void initState() {
    super.initState();
    _firebaseService.getSensorStream().listen((data) {
      final double temp = data['temperature']!;
      final double hum = data['humidity']!;
      setState(() {
        _tempData.add(SensorData(_timeCounter, temp));
        _humData.add(SensorData(_timeCounter, hum));

        // Keep last 20 points
        if (_tempData.length > 20) {
          _tempData.removeAt(0);
        }
        if (_humData.length > 20) {
          _humData.removeAt(0);
        }
        _timeCounter += 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DHT22 Graph'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        color: Colors.lightGreen[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Real-Time Chart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(title: AxisTitle(text: 'Time')),
                primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <LineSeries<SensorData, double>>[
                  LineSeries<SensorData, double>(
                    name: 'Temperature (°C)',
                    dataSource: _tempData,
                    xValueMapper: (SensorData data, _) => data.timeIndex,
                    yValueMapper: (SensorData data, _) => data.value,
                    color: Colors.red,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                  LineSeries<SensorData, double>(
                    name: 'Humidity (%)',
                    dataSource: _humData,
                    xValueMapper: (SensorData data, _) => data.timeIndex,
                    yValueMapper: (SensorData data, _) => data.value,
                    color: Colors.blue,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
