import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';
import 'backend/backendtest.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});
  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<StepData> chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    String? userId = UserSession.getUserId();
    if (userId != null) {
      UserStepsService userStepsService = UserStepsService();
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      List<StepData> fetchedData = await getWeeklyStepData(userId, startOfWeek, now);
      setState(() {
        chartData = fetchedData;
      });
    }
  }

  Future<List<StepData>> getWeeklyStepData(String userId, DateTime start, DateTime end) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('UserSteps')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();

    Map<String, int> stepsMap = {};

    for (var doc in querySnapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      String key = DateFormat('yyyy-MM-dd').format(date);

      if (stepsMap.containsKey(key)) {
        stepsMap[key] = stepsMap[key]! + (doc['stepAmount'] as int);
      } else {
        stepsMap[key] = (doc['stepAmount'] as int);
      }
    }

    // Fill in missing days with 0 steps
    for (DateTime date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(Duration(days: 1))) {
      String day = DateFormat('yyyy-MM-dd').format(date);
      if (!stepsMap.containsKey(day)) {
        stepsMap[day] = 0;
      }
    }

    List<StepData> stepDataList = stepsMap.entries
        .map((entry) => StepData(entry.key, entry.value))
        .toList();

    // Sort the stepDataList by date
    stepDataList.sort((a, b) => a.day.compareTo(b.day));

    // Convert date format for display
    stepDataList = stepDataList.map((data) {
      String displayDate = DateFormat('d MMM').format(DateFormat('yyyy-MM-dd').parse(data.day));
      return StepData(displayDate, data.steps);
    }).toList();

    return stepDataList;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(fontFamily: "Poppins"),
        majorGridLines: MajorGridLines(
          width: 0, // Hides grid lines
        ),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat('#'),
        majorGridLines: const MajorGridLines(
          width: 0, // Hides grid lines
        ),
      ),
      series: <CartesianSeries>[
        ColumnSeries<StepData, String>(
          dataSource: chartData,
          xValueMapper: (StepData data, _) => data.day,
          yValueMapper: (StepData data, _) => data.steps,
          color: Colors.blue, // Change to your desired color
        ),
      ],
    );
  }
}

// StepData class
class StepData {
  final String day;
  final int steps;

  StepData(this.day, this.steps);
}

class ChartDataProvider with ChangeNotifier {


}