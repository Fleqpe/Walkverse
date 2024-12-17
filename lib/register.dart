import 'package:flutter/material.dart';
import 'package:walkverse/landing.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/login.dart';
import 'package:walkverse/renkler.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
              buildTextField(
                  controller: usernameController, label: 'Kullanıcı Adı'),
              const SizedBox(height: 10),
              buildTextField(controller: emailController, label: 'E-posta'),
              const SizedBox(height: 10),
              buildTextField(
                  controller: passwordController,
                  label: 'Şifre',
                  isPassword: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  navigateTo(context, const Landing(), false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent3Color,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: createText("Kayıt Ol", 18),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  navigateTo(context, const LoginPage(), false);
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
