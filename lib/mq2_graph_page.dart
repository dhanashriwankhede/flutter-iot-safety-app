import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'firebase_service.dart';

class MQ2GraphPage extends StatefulWidget {
  const MQ2GraphPage({super.key});

  @override
  State<MQ2GraphPage> createState() => _MQ2GraphPageState();
}

class _MQ2GraphPageState extends State<MQ2GraphPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MQ2 CO Graph"),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getMQ2HistoryStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!
              .map((e) => _ChartData(e['timestamp'], e['value']))
              .toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(title: AxisTitle(text: "Timestamp")),
            primaryYAxis: NumericAxis(title: AxisTitle(text: "CO PPM")),
            title: ChartTitle(text: "CO Level Over Time"),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<_ChartData, String>>[
              LineSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.timestamp,
                yValueMapper: (_ChartData data, _) => data.value,
                name: 'CO PPM',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          );
        },
      ),
    );
  }
}

class _ChartData {
  final String timestamp;
  final double value;

  _ChartData(this.timestamp, this.value);
}
