import 'package:flutter/material.dart';
import 'package:walkverse/anasayfa.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/forgot_password.dart';
import 'package:walkverse/register.dart';
import 'package:walkverse/renkler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend/backendtest.dart';
import 'landing.dart'; // Import the landing page

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
                    child: Text('Giriş Yap'),
                  ),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Kayıt Ol'),
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

    User? user = await _userStepsService.loginUser(email, password);

    if (user != null) {
      // Successful login, navigate to landing page and store user session
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Landing()),
      );
    } else {
      // Display error message
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  Future<void> _register() async {
    final email = _usernameController.text;
    final password = _passwordController.text;

    User? user = await _userStepsService.registerUser(email, password);

    if (user != null) {
      // Successful registration, navigate to landing page and store user session
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Landing()),
      );
    } else {
      // Display error message
      setState(() {
        _errorMessage = 'Registration failed';
      });
    }
  }
}
