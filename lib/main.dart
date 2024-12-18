import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:walkverse/chart.dart';
import 'package:provider/provider.dart';
import 'package:walkverse/login.dart';
import 'package:walkverse/pedometer_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp();
  await requestPermissions(); // Request necessary permissions
  await pedometer_service().initializeService(); // Initialize the singleton service

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ChartDataProvider())],
    child: const MyApp(),
  ));
}

Future<void> requestPermissions() async {
  await [
    Permission.activityRecognition,
    Permission.locationWhenInUse,
    Permission.locationAlways,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}