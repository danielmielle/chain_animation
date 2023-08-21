import 'package:flutter/material.dart';

typedef ChainAnimationBuilder = Widget? Function(
    BuildContext context,
    Widget child,
    );

class ChainAnimationController {
  ValueNotifier<ChainAnimationBuilder> callbackNotifier =
  ValueNotifier((context, child) {
    return null;
  });
}