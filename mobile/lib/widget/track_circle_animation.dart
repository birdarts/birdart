import 'dart:math' as math;

import 'package:flutter/material.dart';

class TrackCircleAnimation extends StatefulWidget {
  const TrackCircleAnimation({Key? key}) : super(key: key);

  @override
  State<TrackCircleAnimation> createState() => _TrackCircleAnimationState();
}

class _TrackCircleAnimationState extends State<TrackCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: CirclePainter(_animation.value),
              child: Container(),
            );
          },
        ),
        const Center(
          child: Icon(
            Icons.my_location_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final double value;

  CirclePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, getRadius(0, size), getPaint(0));
    canvas.drawCircle(center, getRadius(1, size), getPaint(1));
    canvas.drawCircle(center, getRadius(2, size), getPaint(2));
  }

  Paint getPaint(int index) => Paint()
    ..color = Color.fromRGBO(255, 255, 255, (3 - index - value) / 3)
    ..style = PaintingStyle.fill;

  double getRadius(int index, Size size) =>
      math.min(size.width, size.height) / 2 * (value + index) / 3;

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
