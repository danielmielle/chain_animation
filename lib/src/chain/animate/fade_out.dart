import 'package:flutter/material.dart';

import '../chain_animation.dart';
import '../chain_animation_controller.dart';

class FadeOutAnimation extends ExitAnimation {
  FadeOutAnimation({required super.duration, required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    opa = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
  }

  final TickerProvider vsync;
  late AnimationController controller;
  late Animation<double> opa;

  @override
  Function()? get triggerAnimation => () {
        controller.forward();
        // opa = CurvedAnimation(parent: controller, curve: Curves.easeOut);
      };

  @override
  ChainAnimationBuilder get chainAnimationBuilder {
    return (context, child) {
      return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Opacity(
            opacity: opa.value,
            child: child,
          );
        },
        child: child,
      );
    };
  }
}
