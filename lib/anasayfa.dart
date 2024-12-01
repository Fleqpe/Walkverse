import 'package:flutter/material.dart';
import 'package:walkverse/chart.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/profile.dart';
import 'package:walkverse/renkler.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _selectedIndex = 0; // Variable to track selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Add the actions you want to trigger based on the selected index
    switch (index) {
      case 0:
        // Perform actions for Home tab
        break;
      case 1:
        // Perform actions for Location tab
        break;
      case 2:
        // Perform actions for Steps tab
        break;
      case 3:
        navigateTo(context, const ProfilePage(), true);
        break;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mainColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: accentColor,
        selectedFontSize: 0,
        items: [
          createBottomNavigationBarItem("Images/Location.png"),
          createBottomNavigationBarItem("Images/Steps.png"),
          createBottomNavigationBarItem("Images/Leaderboard.png"),
          createBottomNavigationBarItem("Images/Character.png")
        ],
      ),
      appBar: AppBar(
        actions: [
          createIconButton("Images/Settings.png",
              () => {_scaffoldKey.currentState?.openEndDrawer()})
        ],
        title: createText("ANASAYFA", 34),
        centerTitle: false,
        backgroundColor: mainColor,
      ),
      body: mainPageWidget(),
      endDrawer: Drawer(
        // Sağdan kayan menü
        child: Container(
          color: accentColor,
          child: Column(
            children: [
              ListTile(
                title: const Text('Ayarlar', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Ayarlara gitmek için buraya işlem ekleyebilirsiniz
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Çıkış işlemi yapılacaksa buraya kod ekleyebilirsiniz
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget mainPageWidget() {
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
                      createText("Barış Kurt", 16),
                      createText("Lv. 9", 16)
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
                  child: createText("%100", 30),
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
                          createText("3655", 30)
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
                            createText("3655", 30)
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
