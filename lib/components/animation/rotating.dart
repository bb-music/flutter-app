import 'package:flutter/material.dart';

class RotatingContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const RotatingContainer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  @override
  RotatingContainerState createState() => RotatingContainerState();
}

class RotatingContainerState extends State<RotatingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: -1.0).animate(_controller),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
