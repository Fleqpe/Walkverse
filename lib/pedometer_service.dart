import 'dart:async';
import 'dart:developer';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pedometer/pedometer.dart';

import 'backend/backendtest.dart';

class pedometer_service {
  pedometer_service._privateConstructor();
  static final pedometer_service _instance = pedometer_service._privateConstructor();
  factory pedometer_service() {
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
    } catch (e) {
      log("Error sending steps to database: $e");
    }
  }

  int getCurrentStepCount() {
    return stepCount;
  }
}

// Top-level function for onStart
void onStart(ServiceInstance service) {

  // Pedometer ile adım sayısını dinle
  Pedometer.stepCountStream.listen((event) {
    pedometer_service().stepCount = event.steps;
    service.invoke("update", {"steps": pedometer_service().stepCount});
    log("Adım Sayısı: ${pedometer_service().stepCount}"); // Konsola yazdır
  });

  Timer.periodic(const Duration(minutes: 1), (timer) {
    Timer.run(() async {
      int temp = pedometer_service().stepCount;
      pedometer_service().stepCount = pedometer_service().stepCount - pedometer_service().lastStepCount;
      pedometer_service().lastStepCount = temp;
      await pedometer_service().sendStepsToDatabase(pedometer_service().stepCount);
    });
  });
}