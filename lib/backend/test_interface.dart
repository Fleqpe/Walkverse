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
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _stepAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> _userSteps = [];

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
}