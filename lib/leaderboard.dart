import 'package:flutter/material.dart';
import 'package:walkverse/renkler.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LeaderboardPage(),
    );
  }
}

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String filterType = "Dünya"; // Dünya, Yerel, Arkadaşlar
  String timeFilter = "Hafta"; // Hafta, Ay, Yıl

  final List<Map<String, dynamic>> leaderboardData = [
    {"username": "CanKarahan03", "steps": 6782},
    {"username": "Excalibur", "steps": 10},
    {"username": "SwiftWalker", "steps": 5400},
    {"username": "RunMachine", "steps": 3200},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainColor, // Set background color
        child: Column(
          children: [
            // Filtreler
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleButtons(
                    isSelected: [
                      filterType == "Dünya",
                      filterType == "Yerel",
                      filterType == "Arkadaşlar"
                    ],
                    onPressed: (index) {
                      setState(() {
                        filterType = ["Dünya", "Yerel", "Arkadaşlar"][index];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    selectedColor: Colors.white,
                    fillColor: accent3Color,
                    color: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Dünya"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Yerel"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Arkadaşlar"),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: timeFilter,
                    items: const [
                      DropdownMenuItem(value: "Hafta", child: Text("Hafta")),
                      DropdownMenuItem(value: "Ay", child: Text("Ay")),
                      DropdownMenuItem(value: "Yıl", child: Text("Yıl")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        timeFilter = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Lider Tablosu
            Expanded(
              child: ListView.builder(
                itemCount:
                    leaderboardData.length + 1, // Add 1 for the header row
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "SIRA",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "KULLANICI ADI",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ADIM",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final user =
                      leaderboardData[index - 1]; // Adjust index for data
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          index == 1 ? Colors.lightGreenAccent : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index}.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: index == 1 ? Colors.green : Colors.black,
                          ),
                        ),
                        Text(
                          user["username"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color:
                                index == 1 ? Colors.green[800] : Colors.black,
                          ),
                        ),
                        Text(
                          "${user["steps"]} adım",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
