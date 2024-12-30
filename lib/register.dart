import 'package:flutter/material.dart';
import 'package:walkverse/landing.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/login.dart';
import 'package:walkverse/renkler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend/backendtest.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthService _authService = AuthService();
  

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
    final usernameController = _usernameController;
    final emailController = _emailController;
    final passwordController = _passwordController;

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
                onPressed: () async{
                  String result =  await _register() as String;
                  if(result == "succes"){
                    navigateTo(context, const LoginPage(), false);
                  }
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

  Future<String> _register() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final username = _usernameController.text.trim(); 

  if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
    try {
      final user = await _authService.registerUser(email: email, password: password, username: username);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt Başarılı: ${user.email}")),
        );
        return "succes";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt Başarısız")),
        );
        return "failure";
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
      return "error";
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lütfen tüm alanları doldurun")),
    );
    return "fields_empty";
  }
}

}
