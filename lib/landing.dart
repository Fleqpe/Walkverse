import 'package:flutter/material.dart';
import 'package:walkverse/anasayfa.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/profile.dart';
import 'package:walkverse/renkler.dart';
import 'package:walkverse/leaderboard.dart';
import 'package:walkverse/steps.dart';
import 'backend/backendtest.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  var currentWidgetText = "ANASAYFA";
  Widget currentWidget = const Anasayfa();
  int _selectedIndex = 0; // Variable to track selected index

  void changeCurrentWidget(Widget newWidget, String newTitle) {
    setState(() {
      currentWidget = newWidget;
      currentWidgetText = newTitle;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Add the actions you want to trigger based on the selected index
    switch (index) {
      case 0:
        changeCurrentWidget(const Anasayfa(), "ANASAYFA");
        break;
      case 1:
        changeCurrentWidget(const StepDetailsWidget(), "ADIMLAR");
        break;
      case 2:
        changeCurrentWidget(LeaderboardPage(), "LİDER TABLOSU");
        break;
      case 3:
        changeCurrentWidget(
            ProfilePage(changeCurrentWidget: changeCurrentWidget), "PROFİL");
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
          createBottomNavigationBarItem("Images/Home.png"),
          createBottomNavigationBarItem("Images/Steps.png"),
          createBottomNavigationBarItem("Images/Leaderboard.png"),
          BottomNavigationBarItem(
              icon: AvatarWidget(
                avatarItem: avatarItem,
                width: 50,
                height: 50,
              ),
              label: "2")
        ],
      ),
      appBar: AppBar(
        actions: [
          createIconButton("Images/Settings.png",
              () => {_scaffoldKey.currentState?.openEndDrawer()})
        ],
        title: createText(currentWidgetText, 34),
        centerTitle: false,
        backgroundColor: mainColor,
      ),
      body: currentWidget,
      endDrawer: Drawer(
        child: Container(
          color: accentColor,
          child: Column(
            children: [
              ListTile(
                title: const Text('Ayarlar', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                onTap: () {
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
