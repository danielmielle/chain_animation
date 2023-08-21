import 'package:flutter/material.dart';

import '../chain_animation.dart';
import '../chain_animation_controller.dart';

class PopAnimation extends EmphasisAnimation {
  PopAnimation({required super.duration, required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
  }

  final TickerProvider vsync;
  late AnimationController controller;
  late Animation<double> scale;

  @override
  Function()? get triggerAnimation => () {
    controller.forward();
    scale = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  };

  @override
  ChainAnimationBuilder get chainAnimationBuilder {
    return (context, child) {
      return FadeTransition(
        opacity: controller,
        child: ScaleTransition(
          // alignment: Alignment.bottomRight,
          scale: scale,
          child: child,
        ),
      );
    };
  }
}