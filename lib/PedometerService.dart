import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  // Singleton Pattern
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();

  // Stream Controllers
  final StreamController<String> _statusController = StreamController.broadcast();
  final StreamController<String> _stepsController = StreamController.broadcast();

  Stream<String> get statusStream => _statusController.stream;
  Stream<String> get stepsStream => _stepsController.stream;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  // Latest values
  String _status = '?';
  String _steps = '?';

  String get currentStatus => _status;
  String get currentSteps => _steps;    // Adım sayısını db'ye kaydetmek için kullanılabilir.

  // Permission Check
  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }

    return granted;
  }

  // Initialize Pedestrian and Step Streams
  Future<void> initialize() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      _statusController.add('Permission Denied');
      _stepsController.add('Permission Denied');
      return;
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(_onPedestrianStatusChanged).onError(_onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps.toString();
    _stepsController.add(_steps);
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    _statusController.add(_status);
  }

  void _onPedestrianStatusError(error) {
    _status = 'Pedestrian Status not available';
    _statusController.add(_status);
  }

  void _onStepCountError(error) {
    _steps = 'Step Count not available';
    _stepsController.add(_steps);
  }

  // Dispose Streams
  void dispose() {
    _statusController.close();
    _stepsController.close();
  }
}
