import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:walkverse/renkler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend/backendtest.dart';

class StepDetailsWidget extends StatefulWidget {
  const StepDetailsWidget({super.key});

  @override
  _StepDetailsWidgetState createState() => _StepDetailsWidgetState();
}

class _StepDetailsWidgetState extends State<StepDetailsWidget> {
  String selectedTimeframe = "Hafta"; // Default to "Hafta"
  List<StepData> stepData = [];
  int totalSteps = 0;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchStepData();
  }

  Future<void> _fetchStepData() async {
    DateTime now = DateTime.now();
    DateTime startDate;

    if (selectedTimeframe == "Hafta") {
      startDate = now.subtract(Duration(days: now.weekday - 1));
    } else if (selectedTimeframe == "Ay") {
      startDate = DateTime(now.year, now.month, 1);
    } else if (selectedTimeframe == "Yıl") {
      startDate = DateTime(now.year, 1, 1);
    } else if (selectedTimeframe == "Özel" && selectedDateRange != null) {
      startDate = selectedDateRange!.start;
    } else {
      return;
    }

    DateTime endDate = selectedTimeframe == "Özel" && selectedDateRange != null ? selectedDateRange!.end : now;

    List<StepData> fetchedData = await getStepDataForRange(startDate, endDate);
    setState(() {
      stepData = fetchedData;
      totalSteps = calculateTotalSteps(stepData);
    });
  }

  Future<List<StepData>> getStepDataForRange(DateTime start, DateTime end) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('UserSteps')
        .where('userId', isEqualTo: UserSession.getUserId())
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();

    Map<String, int> stepsMap = {};

    for (var doc in querySnapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      String key;
      if (selectedTimeframe == "Yıl") {
        key = DateFormat('MMM').format(date); // Monthly data for year
      } else {
        key = DateFormat('yyyy-MM-dd').format(date); // Daily data for week and month
      }

      if (stepsMap.containsKey(key)) {
        stepsMap[key] = stepsMap[key]! + (doc['stepAmount'] as int);
      } else {
        stepsMap[key] = doc['stepAmount'];
      }
    }

    // Fill in missing days or months with 0 steps
    if (selectedTimeframe == "Yıl") {
      for (int i = 1; i <= 12; i++) {
        String month = DateFormat('MMM').format(DateTime(0, i));
        if (!stepsMap.containsKey(month)) {
          stepsMap[month] = 0;
        }
      }
    } else {
      for (DateTime date = start; date.isBefore(end) || date.isAtSameMomentAs(end); date = date.add(Duration(days: 1))) {
        String day = DateFormat('yyyy-MM-dd').format(date);
        if (!stepsMap.containsKey(day)) {
          stepsMap[day] = 0;
        }
      }
    }

    List<StepData> stepDataList = stepsMap.entries
        .map((entry) => StepData(entry.key, entry.value))
        .toList();

    // Sort the stepDataList by date or month
    if (selectedTimeframe == "Yıl") {
      stepDataList.sort((a, b) => DateFormat('MMM').parse(a.day).compareTo(DateFormat('MMM').parse(b.day)));
    } else {
      stepDataList.sort((a, b) => a.day.compareTo(b.day));
    }

    // Convert date format for display if not yearly
    if (selectedTimeframe != "Yıl") {
      stepDataList = stepDataList.map((data) {
        String displayDate = DateFormat('d MMM').format(DateFormat('yyyy-MM-dd').parse(data.day));
        return StepData(displayDate, data.steps);
      }).toList();
    }

    return stepDataList;
  }

  int calculateTotalSteps(List<StepData> stepData) {
    return stepData.fold(0, (sum, item) => sum + item.steps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Adım Detayları"),
      ),
      body: Container(
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeframe Dropdown
              DropdownButton<String>(
                value: selectedTimeframe,
                items: const [
                  DropdownMenuItem(value: "Hafta", child: Text("Hafta")),
                  DropdownMenuItem(value: "Ay", child: Text("Ay")),
                  DropdownMenuItem(value: "Yıl", child: Text("Yıl")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimeframe = newValue!;
                    _fetchStepData();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Total Steps Display
              Text(
                "Toplam Adım: $totalSteps",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Graph Title
              Text(
                "$selectedTimeframe Grafiği",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Graph
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(
                    labelStyle: const TextStyle(fontFamily: "Poppins"),
                    majorGridLines: const MajorGridLines(
                      width: 0, // Hides grid lines
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat('#'),
                    majorGridLines: const MajorGridLines(
                      dashArray: [5, 5],
                    ),
                  ),
                  series: <ColumnSeries<StepData, String>>[
                    ColumnSeries<StepData, String>(
                      dataSource: stepData,
                      xValueMapper: (StepData data, _) => data.day,
                      yValueMapper: (StepData data, _) => data.steps,
                      color: accent3Color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Date range picker for "Özel" option
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        _fetchStepData();
      });
    }
  }
}

// StepData class
class StepData {
  final String day;
  final int steps;

  StepData(this.day, this.steps);
}

class UserSession {
  static String? userId;

  static void setUserId(String id) {
    userId = id;
  }

  static String? getUserId() {
    return userId;
  }
}
