import 'package:flutter/material.dart';

const Color mainColor = Color(0xFFEBEBEB);
const Color accentColor = Color(0xFF92FF81);
const Color accent2Color = Color(0xFF47813F);
const Color accent3Color = Color(0xFFB47EB3);
const Color textColor = Color(0xFF212121);

String font1 = "Lilita";
String font2 = "Poppins";

ElevatedButton createButton(String buttonText, Function()? onPressed,
    {TextStyle textStyle = const TextStyle(color: textColor),
    ButtonStyle buttonStyle = const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(mainColor))}) {
  return ElevatedButton(
    style: buttonStyle,
    onPressed: onPressed,
    child: Text(
      buttonText,
      style: textStyle,
    ),
  );
}
