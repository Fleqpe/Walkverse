import 'package:flutter/material.dart';
import 'package:walkverse/chart.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';
import 'backend/backendtest.dart';
import 'backend/xpSystem.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  UserStepsService userStepsService = UserStepsService();
  String userName = 'Loading...';
  int level = 0;
  int remainingXp = 0;
  int weeklyGoal = 0;
  int monthlyGoal = 0;
  int weeklyCount = 0;
  int monthlyCount = 0;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userId = UserSession.getUserId();
    if (userId != null) {
      UserStepsService userStepsService = UserStepsService();

      // Fetch username
      userName = await userStepsService.getUsername(userId);

      // Fetch total steps
      int totalSteps = await userStepsService.getTotalSteps(userId);

      // Calculate level and remaining XP
      Map<String, int> levelInfo = XpSystem.calculateLevel(totalSteps);
      level = levelInfo['level']!;
      remainingXp = levelInfo['remainingXp']!;

      // Calculate weekly and monthly goals

      weeklyGoal = XpSystem.calculateWeeklyGoal(level);
      monthlyGoal = XpSystem.calculateMonthlyGoal(level);

      // Calculate weekly steps
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      weeklyCount = await userStepsService.getTotalStepsScaled(userId, startOfWeek, now);

      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      monthlyCount = await userStepsService.getTotalStepsScaled(userId,startOfMonth, now);
      setState(() {});

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        createText(userName, 16),
                        createText("$level lv.", 16)
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
                        createText("BUGÜN ATILAN ADIM SAYISI", 20),
                        createText("10/100", 18),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 40),
                    child: createText("%100", 20),
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
                            createText("HAFTALIK HEDEF", 18),
                            createText("$weeklyCount / $weeklyGoal", 18)
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
                              createText("AYLIK HEDEF", 18),
                              createText("$monthlyCount / $monthlyGoal", 18)
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
                const SizedBox(
                  height: 115,
                  child: ChartWidget(),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}
