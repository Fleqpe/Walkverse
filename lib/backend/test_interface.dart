import 'backendtest.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserStepsScreen(),
    );
  }
}

class UserStepsScreen extends StatefulWidget {
  @override
  _UserStepsScreenState createState() => _UserStepsScreenState();
}

class _UserStepsScreenState extends State<UserStepsScreen> {
  final UserStepsService _userStepsService = UserStepsService();
  final AuthService _authService = AuthService();
  
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _stepAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  List<Map<String, dynamic>> _userSteps = [];
  String errorMessage = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Steps'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _stepAmountController,
              decoration: InputDecoration(labelText: 'Step Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addUserStep,
                  child: Text('Add Step'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _getUserSteps,
                  child: Text('Get Steps'),
                ),
                
              ],
            ),
            SizedBox(height: 20),
            
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "E-posta"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Şifre"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                ElevatedButton(
                  onPressed: _register,
                  child: Text("sing up"),
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text("Login"),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                //Navigator.pushNamed(context, '/signup'); // Kayıt ol sayfasına yönlendirme
              },
              child: Text("Don't have an account? Sign up."),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _userSteps.length,
                itemBuilder: (context, index) {
                  final step = _userSteps[index];
                  return ListTile(
                    title: Text('Steps: ${step['stepAmount']}'),
                    subtitle: Text('Date: ${step['date']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addUserStep() async {
    final userId = _userIdController.text;
    final stepAmount = int.tryParse(_stepAmountController.text) ?? 0;
    final date = DateTime.tryParse(_dateController.text) ?? DateTime.now();

    await _userStepsService.addUserStep(userId, stepAmount, date);
  }

  Future<void> _getUserSteps() async {
    final userId = _userIdController.text;
    final steps = await _userStepsService.getUserSteps(userId);

    setState(() {
      _userSteps = steps;
    });
  }
  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      final user = await _authService.registerUser(email: email, password: password);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt Başarılı: ${user.email}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kayıt Başarısız")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
    }
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty.")),
      );
    
      });
      return;
    }

    String result = await _authService.loginUser(email, password);
    setState(() {
      errorMessage = result;
      
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),);
      
    });

    if (result == "success") {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarılı. Ana sayfaya yönlendirme yapılabilir.")),
      );
    
      });
      // Giriş başarılı. Ana sayfaya yönlendirme yapılabilir.
      //Navigator.pushReplacementNamed(context, '/home');
    }
  }
}