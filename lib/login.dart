import 'package:flutter/material.dart';
import 'package:walkverse/landing.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/forgot_password.dart';
import 'package:walkverse/register.dart';
import 'package:walkverse/renkler.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: accentColor,
        labelText: label,
        labelStyle: TextStyle(fontFamily: font2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

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
              buildTextField(
                  controller: usernameController, label: 'Kullanıcı Adı'),
              const SizedBox(height: 20),
              buildTextField(
                  controller: passwordController,
                  label: 'Şifre',
                  isPassword: true),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      navigateTo(context, const Landing(), false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      minimumSize: const Size(150, 50),
                    ),
                    child: createText("Giriş Yap", 18),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigateTo(context, const RegisterPage(), true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent3Color,
                      minimumSize: const Size(150, 50),
                    ),
                    child: createText("Kayıt Ol", 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  navigateTo(context, const ForgotPasswordPage(), true);
                },
                child: Text(
                  'Şifremi Unuttum',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
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
