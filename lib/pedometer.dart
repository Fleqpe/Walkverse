import 'package:flutter/material.dart';

import 'PedometerService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PedometerService _pedometerService = PedometerService();

  @override
  void initState() {
    super.initState();
    _pedometerService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example with Singleton'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<String>(
                stream: _pedometerService.stepsStream,
                builder: (context, snapshot) {
                  return Text(
                    'Steps Taken: ${snapshot.data ?? '?'}',
                    style: TextStyle(fontSize: 30),
                  );
                },
              ),
              SizedBox(height: 20),
              StreamBuilder<String>(
                stream: _pedometerService.statusStream,
                builder: (context, snapshot) {
                  String status = snapshot.data ?? '?';
                  return Column(
                    children: [
                      Text(
                        'Pedestrian Status: $status',
                        style: TextStyle(fontSize: 30),
                      ),
                      Icon(
                        status == 'walking'
                            ? Icons.directions_walk
                            : status == 'stopped'
                                ? Icons.accessibility_new
                                : Icons.error,
                        size: 100,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pedometerService.dispose();
    super.dispose();
  }
}
