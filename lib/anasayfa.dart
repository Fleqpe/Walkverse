import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetest1/renkler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  void _updateData() {
    // Example: Randomly change step counts for demonstration
    setState(() {
      dataSource[0] = StepData(
          "PZT", 150 + (dataSource[0].stepCount % 10)); // Update first item
      // Update other items similarly...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: accentColor,
        selectedFontSize: 0,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "Images/Home.png",
                height: 40,
                width: 40,
              ),
              label: "2"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "Images/Location.png",
                height: 40,
                width: 40,
              ),
              label: "2"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "Images/Steps.png",
                height: 40,
                width: 40,
              ),
              label: "2"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "Images/Leaderboard.png",
                height: 40,
                width: 40,
              ),
              label: "1"),
          BottomNavigationBarItem(
              icon: Image.asset(
                "Images/Character.png",
                height: 40,
                width: 40,
              ),
              label: "2"),
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Image.asset("Images/Settings.png"),
              iconSize: 50,
              onPressed: () {
                // Update data when settings is pressed (example)
                _updateData();
              })
        ],
        title: Text(
          "ANASAYFA",
          style: TextStyle(color: textColor, fontFamily: font2, fontSize: 34),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Center(
            child: Container(
                width: 400,
                height: 90,
                decoration: createDecoration(accentColor),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "Images/Character.png",
                        width: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Barış Kurt",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: font2,
                                fontSize: 16),
                          ),
                          Text(
                            "Lv. 6",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: font2,
                                fontSize: 16),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                width: 400,
                height: 90,
                decoration: createDecoration(accent3Color),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BUGÜN ATILAN ADIM SAYISI",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: font2,
                                fontSize: 20),
                          ),
                          Text(
                            "100/1000",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: font2,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 40),
                      child: Text(
                        "%100",
                        style: TextStyle(
                            color: textColor, fontFamily: font2, fontSize: 30),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 175,
                    height: 90,
                    decoration: createDecoration(accentColor),
                    child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "HAFTALIK HEDEF",
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: font2,
                                    fontSize: 18),
                              ),
                              Text(
                                "36750",
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily: font2,
                                    fontSize: 30),
                              )
                            ],
                          ),
                        )),
                  ),
                  Container(
                      width: 175,
                      height: 90,
                      decoration: createDecoration(accentColor),
                      child: Padding(
                          padding: const EdgeInsets.only(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "AYLIK HEDEF",
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily: font2,
                                      fontSize: 18),
                                ),
                                Text(
                                  "36750",
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily: font2,
                                      fontSize: 30),
                                )
                              ],
                            ),
                          )))
                ],
              ),
            ),
          )),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 400,
              height: 175,
              decoration: createDecoration(accentColor),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "RAPOR",
                    style: TextStyle(
                        color: textColor, fontFamily: font2, fontSize: 25),
                  ),
                  SizedBox(
                    height: 115,
                    child: createChartWidget(),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

Image characterImage = Image.asset(
  "Images/Character.png",
  height: 75,
  width: 75,
);
BoxDecoration createDecoration(Color backgroundColor) {
  return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: -5,
            blurRadius: 5,
            offset: const Offset(0, 8))
      ]);
}

class StepData {
  StepData(this.day, this.stepCount);

  final String day;
  final int stepCount;
}

SfCartesianChart createChartWidget() {
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
        maximum: getBiggestStepCount(dataSource) * 1.5,
        interval: getBiggestStepCount(dataSource) / 2,
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
        dataSource: dataSource,
        xValueMapper: (StepData steps, _) => steps.day,
        yValueMapper: (StepData steps, _) => steps.stepCount,
      )
    ],
  );
}

List<StepData> dataSource = [
  StepData("PZT", 99),
  StepData("SAL", 5),
  StepData("ÇAR", 23),
  StepData("PER", 36),
  StepData("CUMA", 100),
  StepData("CMT", 700),
  StepData("PZR", 3)
];
double getBiggestStepCount(List<StepData> steps) {
  return steps
      .map((data) => data.stepCount)
      .reduce((a, b) => a > b ? a : b)
      .toDouble();
}
