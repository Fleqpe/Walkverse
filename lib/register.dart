import 'package:flutter/material.dart';
import 'package:walkverse/anasayfa.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/login.dart';
import 'package:walkverse/renkler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
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
              createText("Kayıt Ol", 40),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(fontFamily: font2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  labelText: 'E-posta',
                  labelStyle: TextStyle(fontFamily: font2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: accentColor,
                  labelText: 'Şifre',
                  labelStyle: TextStyle(fontFamily: font2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await navigateTo(context, const Anasayfa(), false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent3Color,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: createText("Kayıt Ol", 18),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  await navigateTo(context, const LoginPage(),
                      false); // Add navigation to login page
                },
                child: Text(
                  'Zaten bir hesabınız var mı?',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontFamily: font2,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
