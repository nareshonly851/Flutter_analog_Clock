import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analog Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analog Clock'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: EdgeInsets.all(20),

            child: CustomPaint(
              painter: ClockPainter(_currentTime),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNotification();
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }

  Future<void> _showNotification() async {
    // Replace this code with your notification implementation
    final String formattedTime =
        "${_currentTime.hour}:${_currentTime.minute}";
    print('Time notification: $formattedTime');
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = centerX;

    // Draw clock face
    final facePaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw hour lines
    final hourLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;
    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180;
      final startX = centerX + cos(angle) * radius * 0.8;
      final startY = centerY + sin(angle) * radius * 0.8;
      final endX = centerX + cos(angle) * radius * 0.9;
      final endY = centerY + sin(angle) * radius * 0.9;
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        hourLinePaint,
      );
    }

    // Draw minute lines
    final minuteLinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    for (int i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        final angle = i * 6 * pi / 180;
        final startX = centerX + cos(angle) * radius * 0.8;
        final startY = centerY + sin(angle) * radius * 0.8;
        final endX = centerX + cos(angle) * radius * 0.85;
        final endY = centerY + sin(angle) * radius * 0.85;
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          minuteLinePaint,
        );
      }
    }

    // Draw hour hand
    final hourHandPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;
    final hourHandLength = radius * 0.4;
    final hourRadians =
        (time.hour * 30 + (time.minute / 2) - 90) * (pi / 180);
    final hourHandX = centerX + cos(hourRadians) * hourHandLength;
    final hourHandY = centerY + sin(hourRadians) * hourHandLength;
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Draw minute hand
    final minuteHandPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    final minuteHandLength = radius * 0.6;
    final minuteRadians = (time.minute * 6 - 90) * (pi / 180);
    final minuteHandX = centerX + cos(minuteRadians) * minuteHandLength;
    final minuteHandY = centerY + sin(minuteRadians) * minuteHandLength;
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    // Draw second hand
    final secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final secondHandLength = radius * 0.8;
    final secondRadians = (time.second * 6 - 90) * (pi / 180);
    final secondHandX = centerX + cos(secondRadians) * secondHandLength;
    final secondHandY = centerY + sin(secondRadians) * secondHandLength;
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);

    // Draw center point
    final centerPointPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 6.0, centerPointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}




