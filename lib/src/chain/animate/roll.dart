import 'package:flutter/material.dart';

import '../chain_animation.dart';
import '../chain_animation_controller.dart';

class RollAnimation extends ExitAnimation {
  RollAnimation({required super.duration, required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  final TickerProvider vsync;
  late AnimationController controller;
  late Animation<AlignmentGeometry> _alignAnimation;
  late Animation<double> _rotationAnimation;

  @override
  Function()? get triggerAnimation => () {
        controller.forward();
      };

  @override
  ChainAnimationBuilder get chainAnimationBuilder {
    return (context, child) {
      return AlignTransition(
          alignment: _alignAnimation,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: child,
          ));
    };
  }
}
