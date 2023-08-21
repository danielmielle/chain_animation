
import 'chain_animation_controller.dart';

abstract class ChainAnimation {
  final Duration duration;

  ChainAnimation({required this.duration});

  ChainAnimationBuilder get chainAnimationBuilder;


  Function()? triggerAnimation;
}

abstract class EntranceAnimation extends ChainAnimation {
  EntranceAnimation({required super.duration});
}

abstract class ExitAnimation extends ChainAnimation {
  ExitAnimation({required super.duration});
}

abstract class EmphasisAnimation extends ChainAnimation {
  EmphasisAnimation({required super.duration});
}