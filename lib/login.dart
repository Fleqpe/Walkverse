import 'package:flutter/material.dart';
import 'package:walkverse/landing.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/forgot_password.dart';
import 'package:walkverse/register.dart';
import 'package:walkverse/renkler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend/backendtest.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserStepsService _userStepsService = UserStepsService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

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
                  controller: _usernameController, label: 'Kullanıcı Adı'),
              const SizedBox(height: 20),
              buildTextField(
                  controller: _passwordController,
                  label: 'Şifre',
                  isPassword: true),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    // () {
                    //   navigateTo(context, const Landing(), false);
                    // },
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
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
  final email = _usernameController.text;
  final password = _passwordController.text;

  // Kullanıcının var olup olmadığını kontrol et
  bool userExists = await _userStepsService.checkIfUserExists(email);

  if (userExists) {
    // Kullanıcı varsa, giriş yapmayı dene
    User? user = await _userStepsService.loginUser(email, password);

    if (user != null) {
      // Başarılı giriş, ana sayfaya yönlendir
      navigateTo(context, const Landing(), false);
    } else {
      // Kullanıcı varsa ama şifre yanlışsa hata mesajı göster
      setState(() {
        _errorMessage = 'Incorrect password. Please try again.';
      });
    }
  } else {
    // Kullanıcı kayıtlı değilse mesaj göster
    setState(() {
      _errorMessage = 'User not found. Please sign up.';
    });
  }
}
}

