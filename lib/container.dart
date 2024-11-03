import 'package:flutter/material.dart';
import 'package:walkverse/renkler.dart';

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

double getBiggestStepCount(List<StepData> steps) {
  return steps
      .map((data) => data.stepCount)
      .reduce((a, b) => a > b ? a : b)
      .toDouble();
}

BottomNavigationBarItem createBottomNavigationBarItem(String imageString) {
  return BottomNavigationBarItem(
      icon: Image.asset(
        imageString,
        height: 40,
        width: 40,
      ),
      label: "2");
}

IconButton createIconButton(String imageString, Function() onPressed) {
  return IconButton(
      icon: Image.asset(imageString), iconSize: 50, onPressed: onPressed);
}

Text createText(String content, double? fontsize) {
  return Text(
    content,
    style: TextStyle(color: textColor, fontFamily: font2, fontSize: fontsize),
  );
}

Future<void> navigateTo(
    BuildContext context, Widget page, bool canGoBack) async {
  if (canGoBack) {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  } else {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false,
    );
  }
}
