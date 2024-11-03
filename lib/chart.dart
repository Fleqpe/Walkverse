import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});
  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    final chartData = Provider.of<ChartDataProvider>(context);

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(fontFamily: "Poppins"),
        majorGridLines: MajorGridLines(
          width: 2,
          dashArray: [10, 10], // Makes the grid lines dashed
          color: accent2Color, // Sets color of the dashed lines
        ),
      ),
      primaryYAxis: NumericAxis(
          numberFormat: NumberFormat('#'),
          maximum: getBiggestStepCount(chartData.dataSource) * 1.5,
          interval: getBiggestStepCount(chartData.dataSource) / 2,
          majorGridLines: const MajorGridLines(
            width: 2,
            dashArray: [10, 10], // Makes the grid lines dashed
            color: accent2Color, // Sets color of the dashed lines
          ),
          labelStyle: const TextStyle(fontFamily: "Poppins")),
      series: <LineSeries<StepData, String>>[
        LineSeries<StepData, String>(
          color: accent3Color,
          width: 3,
          markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              width: 10,
              height: 10,
              color: mainColor),
          dataSource: chartData.dataSource,
          xValueMapper: (StepData steps, _) => steps.day,
          yValueMapper: (StepData steps, _) => steps.stepCount,
        )
      ],
    );
  }
}

class ChartDataProvider with ChangeNotifier {
  List<StepData> dataSource = [
    StepData("PZT", 9929),
    StepData("SAL", 5),
    StepData("ÇAR", 23),
    StepData("PER", 36),
    StepData("CUMA", 100),
    StepData("CMT", 700),
    StepData("PZR", 3)
  ];
  List<StepData> get data => dataSource;

  double getBiggestStepCount() {
    return dataSource
        .map((data) => data.stepCount)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
  }

  void updateData(List<StepData> newData) {
    dataSource = newData;
    notifyListeners();
  }
}
