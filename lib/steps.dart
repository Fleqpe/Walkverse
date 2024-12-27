import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:walkverse/renkler.dart';

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
    stepData = getDummyData("Hafta");
    totalSteps = calculateTotalSteps(stepData);
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
                  DropdownMenuItem(value: "Özel", child: Text("Özel")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTimeframe = value!;
                    if (selectedTimeframe == "Özel") {
                      _selectDateRange(); // Show date range picker for "Özel"
                    } else {
                      stepData = getDummyData(selectedTimeframe);
                      totalSteps = calculateTotalSteps(stepData);
                    }
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
                      yValueMapper: (StepData data, _) => data.stepCount,
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

  // Dummy data generator for Hafta, Ay, and Yıl
  List<StepData> getDummyData(String timeframe) {
    if (timeframe == "Hafta") {
      return [
        StepData("Pzt", 1200),
        StepData("Sal", 2300),
        StepData("Çar", 1800),
        StepData("Per", 2400),
        StepData("Cum", 2200),
        StepData("Cmt", 3000),
        StepData("Pzr", 2800),
      ];
    } else if (timeframe == "Ay") {
      return List.generate(
          30, (index) => StepData("Gün ${index + 1}", (index + 1) * 100));
    } else if (timeframe == "Yıl") {
      return List.generate(
          12, (index) => StepData("Ay ${index + 1}", (index + 1) * 1000));
    } else {
      return [];
    }
  }

  // Calculate total steps
  int calculateTotalSteps(List<StepData> data) {
    return data.fold(0, (total, item) => total + item.stepCount);
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
        // Generate dummy data based on the selected date range (you can replace this with real data)
        stepData = getDummyDataForRange(picked.start, picked.end);
        totalSteps = calculateTotalSteps(stepData);
      });
    }
  }

  // Generate dummy data based on date range (replace with real data logic)
  List<StepData> getDummyDataForRange(DateTime start, DateTime end) {
    int days = end.difference(start).inDays;
    return List.generate(
      days + 1,
      (index) => StepData(
        DateFormat('d MMM').format(start.add(Duration(days: index))),
        (index + 1) * 500, // Dummy step count
      ),
    );
  }
}

// StepData class
class StepData {
  final String day;
  final int stepCount;

  StepData(this.day, this.stepCount);
}
