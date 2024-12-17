import 'package:flutter/material.dart';
import 'package:walkverse/landing.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Şifremi Unuttum",
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontFamily: font2))
          ],
        ),
        backgroundColor: accentColor,
        iconTheme: const IconThemeData(color: textColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Şifrenizi sıfırlamak için e-posta adresinizi girin.",
                style: TextStyle(
                    fontSize: 18, fontFamily: font2, color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  labelText: 'E-posta Adresi',
                  labelStyle: TextStyle(fontFamily: font2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await navigateTo(context, const Landing(), false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent3Color,
                  minimumSize: const Size(200, 50),
                ),
                child: Text(
                  "Şifre Sıfırlama E-postası Gönder",
                  style: TextStyle(
                      fontSize: 16, fontFamily: font2, color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
