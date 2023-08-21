import 'package:flutter/material.dart';

import '../chain_animation.dart';
import '../chain_animation_controller.dart';

class FadeInAnimation extends EntranceAnimation {
  FadeInAnimation({required super.duration, required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }

  final TickerProvider vsync;
  late AnimationController controller;

  @override
  Function()? get triggerAnimation => () {
    controller.forward();
  };

  @override
  ChainAnimationBuilder get chainAnimationBuilder {
    return (context, child) {
      return FadeTransition(
        opacity: controller,
        child: child,
      );
    };
  }
}