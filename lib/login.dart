import 'package:flutter/material.dart';
import 'package:walkverse/anasayfa.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/forgot_password.dart';
import 'package:walkverse/register.dart';
import 'package:walkverse/renkler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              createText("Giriş Yap", 40),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(fontFamily: font2),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Köşeleri yuvarlama
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: accentColor,
                    labelText: 'Sifre',
                    labelStyle: TextStyle(fontFamily: font2),
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await navigateTo(context, const Anasayfa(), false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        minimumSize: const Size(150, 50)),
                    child: createText("Giriş Yap", 18),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await navigateTo(context, const RegisterPage(), true);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: accent3Color,
                        minimumSize: const Size(150, 50)),
                    child: createText("Kayıt Ol", 18),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await navigateTo(context, const ForgotPasswordPage(), true);
                },
                child: Text(
                  'Sifremi Unuttum',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontFamily: font2,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
