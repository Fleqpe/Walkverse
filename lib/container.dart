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
    await Navigator.push(
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

class AvatarItem {
  int headId;
  int hairId;
  int glassesId;
  int outfitId;

  AvatarItem({
    required this.headId,
    required this.hairId,
    required this.glassesId,
    required this.outfitId,
  });
}

AvatarItem avatarItem =
    AvatarItem(headId: 1, hairId: 1, glassesId: 1, outfitId: 1);

class AvatarWidget extends StatelessWidget {
  final AvatarItem avatarItem;
  final double width;
  final double height;

  const AvatarWidget({
    Key? key,
    required this.avatarItem,
    this.width = 150,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
        border: Border.all(
          color: Colors.black, // Outline rengi
          width: width / 25, // Outline kalınlığı
        ),
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('Images/Characters/Outfit/${avatarItem.outfitId}.png'),
            Image.asset('Images/Characters/Heads/${avatarItem.headId}.png'),
            Image.asset('Images/Characters/Hairs/${avatarItem.hairId}.png'),
            Image.asset(
                'Images/Characters/Eyeglasses/${avatarItem.glassesId}.png'),
          ],
        ),
      ),
    );
  }
}
