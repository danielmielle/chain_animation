import 'package:flutter/material.dart';

import 'chain_animation_controller.dart';

class ChainAnimatedWidget extends StatefulWidget {
  final ChainAnimationController controller;
  final Widget child;

  ChainAnimatedWidget({required this.controller, required this.child});

  @override
  _ChainAnimatedWidgetState createState() => _ChainAnimatedWidgetState();
}

class _ChainAnimatedWidgetState extends State<ChainAnimatedWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ChainAnimationController controller = widget.controller;

    var notifier = controller.callbackNotifier;

    return ValueListenableBuilder<ChainAnimationBuilder>(
      valueListenable: notifier,
      builder: (context, value, child) {
        var widget2 = value.call(context, widget.child);

        if (widget2 == null) {
          return widget.child;
        }
        return widget2;
      },
    );
  }
}