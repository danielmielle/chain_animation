// import 'package:flutter/material.dart';
//
// import '../chain_animation.dart';
// import '../chain_animation_controller.dart';
//
// class BounceAnimation extends EntranceAnimation {
//   BounceAnimation({required super.duration, required this.vsync}) {
//     controller = AnimationController(
//       vsync: vsync,
//       duration: duration,
//     );
//   }
//
//   final TickerProvider vsync;
//   late AnimationController controller;
//   late Animation<double> chained;
//   double _vert = 0;
//   double height = 100;
//
//   @override
//   Function()? get triggerAnimation => () {
//     chained = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Curves.easeIn,
//         reverseCurve: Curves.easeOut,
//       ),
//     );
//     controller.repeat(reverse: true);
//   };
//
//   @override
//   ChainAnimationBuilder get chainAnimationBuilder {
//     return (context, child) {
//       return Transform.translate(
//         offset: Offset(_vert, 1 * chained.value * height),
//         child: child,
//       );
//     };
//   }
// }
import 'package:flutter/material.dart';

import '../chain_animation.dart';
import '../chain_animation_controller.dart';


class BounceAnimation extends ExitAnimation {
  BounceAnimation({required super.duration, required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: duration,
    );
    position = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.bounceInOut),
      ),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bounceCount++;
        if (bounceCount < 3) {
          controller.reverse();
        } else {
          controller.reset(); // Reset the controller to initial state
        }
      } else if (status == AnimationStatus.dismissed) {
        if (bounceCount < 3) {
          controller.forward();
        }
      }
    });
  }

  final TickerProvider vsync;
  late AnimationController controller;
  late Animation<double> position;
  int bounceCount = 0;

  @override
  Function()? get triggerAnimation => () {
    controller.forward();
  };

  @override
  ChainAnimationBuilder get chainAnimationBuilder {
    return (context, child) {
      return AnimatedBuilder(
        animation: position,
        builder: (context, child) {
          return FadeTransition(
            opacity: controller,
            child: Transform.translate(
              offset: Offset(0, -3 * (position.value)),
              child: child,
            ),
          );
        },
        child: child,
      );
    };
  }
}