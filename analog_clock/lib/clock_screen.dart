import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';


/// AnalogClock Widget
///
/// Represents an analog clock with customizable appearance and functionality.
/// Author: Sitharaj Seenivasan
class AnalogClock extends StatefulWidget {
  const AnalogClock({Key? key}) : super(key: key);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late Timer _timer;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AnalogClockPainter(dateTime: _dateTime),
      ),
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final DateTime dateTime;
  final double hourHandLengthFraction = 0.45;
  final double minuteHandLengthFraction = 0.6;
  final double secondHandLengthFraction = 0.7;

  _AnalogClockPainter({required this.dateTime});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.shortestSide / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw outer circle
    final outerCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, outerCirclePaint);

    // Draw clock face
    final clockFacePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius - 2, clockFacePaint);

    // Draw hour hand
    final hourHandPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = radius * 0.03;
    final double hourHandAngle =
        (dateTime.hour % 12 + dateTime.minute / 60) * math.pi / 6;
    final double hourHandLength = radius * hourHandLengthFraction;
    final double hourHandX = centerX + hourHandLength * math.sin(hourHandAngle);
    final double hourHandY = centerY - hourHandLength * math.cos(hourHandAngle);
    canvas.drawLine(
        Offset(centerX, centerY), Offset(hourHandX, hourHandY), hourHandPaint);

    // Draw minute hand
    final minuteHandPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = radius * 0.02;
    final double minuteHandAngle =
        (dateTime.minute + dateTime.second / 60) * math.pi / 30;
    final double minuteHandLength = radius * minuteHandLengthFraction;
    final double minuteHandX =
        centerX + minuteHandLength * math.sin(minuteHandAngle);
    final double minuteHandY =
        centerY - minuteHandLength * math.cos(minuteHandAngle);
    canvas.drawLine(Offset(centerX, centerY), Offset(minuteHandX, minuteHandY),
        minuteHandPaint);

    // Draw second hand
    final secondHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = radius * 0.01;
    final double secondHandAngle = (dateTime.second) * math.pi / 30;
    final double secondHandLength = radius * secondHandLengthFraction;
    final double secondHandX =
        centerX + secondHandLength * math.sin(secondHandAngle);
    final double secondHandY =
        centerY - secondHandLength * math.cos(secondHandAngle);
    canvas.drawLine(Offset(centerX, centerY), Offset(secondHandX, secondHandY),
        secondHandPaint);

    // Draw numbers
    final numbersRadius = radius * 0.8;
    final numbersTextStyle = TextStyle(
      color: Colors.black,
      fontSize: radius * 0.1,
      fontWeight: FontWeight.bold,
    );
    final numbersPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 1; i <= 12; i++) {
      final double angle = i * 30 * math.pi / 180;
      final double numberX = centerX + (numbersRadius * math.sin(angle));
      final double numberY = centerY - (numbersRadius * math.cos(angle));
      final numberTextSpan = TextSpan(text: '$i', style: numbersTextStyle);
      numbersPainter.text = numberTextSpan;
      numbersPainter.layout();
      numbersPainter.paint(
        canvas,
        Offset(numberX - (numbersPainter.width / 2),
            numberY - (numbersPainter.height / 2)),
      );
    }

    // Draw dividers
    final dividerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = radius * 0.01;

    for (int i = 0; i < 60; i++) {
      final double angle = i * 6 * math.pi / 180;
      final double startX = centerX + (radius * math.sin(angle));
      final double startY = centerY - (radius * math.cos(angle));
      final double endX =
          centerX + ((radius - (radius * 0.07)) * math.sin(angle));
      final double endY =
          centerY - ((radius - (radius * 0.07)) * math.cos(angle));

      dividerPaint.strokeWidth = i % 5 == 0 ? (radius * 0.02) : (radius * 0.01);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), dividerPaint);
    }


    // Draw center dot
    final centerDotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.05, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
