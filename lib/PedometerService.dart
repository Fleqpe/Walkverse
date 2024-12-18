import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pedometer/pedometer.dart';

import 'backend/backendtest.dart';

class PedometerService {
  PedometerService._privateConstructor();
  static final PedometerService _instance = PedometerService._privateConstructor();
  factory PedometerService() {
    return _instance;
  }

  final service = FlutterBackgroundService();
  final _userStepsService = UserStepsService();
  int stepCount = 0;
  int lastStepCount = 0;

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true, // Ensure foreground mode is enabled
        autoStart: true,
      ),
      iosConfiguration: IosConfiguration(), // iOS desteği için boş bırakabilirsiniz
    );

    // Servisi başlat
    service.startService();
  }
  
  Future<void> sendStepsToDatabase(int steps) async {
    try {
      await _userStepsService.addUserStep("userId", steps, DateTime.now());
      print("Steps sent to database: $steps");
    } catch (e) {
      print("Error sending steps to database: $e");
    }
  }

  int getCurrentStepCount() {
    return stepCount;
  }

  static void onStart(ServiceInstance service) {
    // Pedometer ile adım sayısını dinle
    Pedometer.stepCountStream.listen((event) {
      _instance.stepCount = event.steps;
      service.invoke("update", {"steps": _instance.stepCount});
      print("Adım Sayısı: ${_instance.stepCount}"); // Konsola yazdır
    });

    Timer.periodic(const Duration(minutes: 1), (timer) {
      Timer.run(() async {
        int temp = _instance.stepCount;
        _instance.stepCount = _instance.stepCount - _instance.lastStepCount;
        _instance.lastStepCount = temp;
        await _instance.sendStepsToDatabase(_instance.stepCount);
      });
    });
  }
}
