import 'dart:async';
import 'chain_animation.dart';
import 'chain_animation_controller.dart';

class ChainAnimationHelper {
  final List<Execution> _pendingTasks = [];
  bool cancelRequested = false;

  ChainAnimationHelper execute(
    ChainAnimationController controller,
    ChainAnimation animation,
  ) {
    _pendingTasks.add(
      Execution(
        function: () async {
          controller.callbackNotifier.value = animation.chainAnimationBuilder;

          await Future.microtask(() {
            animation.triggerAnimation?.call();
          });
          await Future.delayed(animation.duration);
        },
        type: ExecutionType.execute,
      ),
    );
    return this;
  }

  ChainAnimationHelper executeAfter(
    ChainAnimationController controller,
    ChainAnimation animation,
  ) {
    _pendingTasks.add(
      Execution(
        function: () async {
          controller.callbackNotifier.value = animation.chainAnimationBuilder;

          await Future.microtask(() {
            animation.triggerAnimation?.call();
          });
          await Future.delayed(animation.duration);
        },
        type: ExecutionType.executeAfter,
      ),
    );
    return this;
  }

  ChainAnimationHelper stop(ChainAnimationController controller) {
    _pendingTasks.add(
      Execution(
        function: () async {
          await Future.delayed(const Duration(seconds: 1));
          // controller.callbackNotifier.dispose();
        },
        type: ExecutionType.stop,
      ),
    );
    return this;
  }

  ChainAnimationHelper stopAfter(ChainAnimationController controller) {
    _pendingTasks.add(
      Execution(
        function: () async {
          await Future.delayed(const Duration(seconds: 1));
          // controller.callbackNotifier.dispose();
        },
        type: ExecutionType.stopAfter,
      ),
    );
    return this;
  }

  ChainAnimationHelper delay(Duration duration) {
    _pendingTasks.add(
      Execution(
        function: () async {
          await Future.delayed(duration);
        },
        type: ExecutionType.delay,
      ),
    );
    return this;
  }

  ChainAnimationHelper flush() {
    cancelRequested = true;
    _pendingTasks.clear();

    return this;
  }

  ChainAnimationHelper then(FutureCallBack callBack) {
    _pendingTasks.add(
      Execution(
        function: () async {
          await callBack.call();
        },
        type: ExecutionType.then,
      ),
    );
    return this;
  }

  Future<void> run() async {
    // run({required super.onFinish});
    cancelRequested = false;

    for (int index = 0; index < _pendingTasks.length; index++) {
      final Execution execution = _pendingTasks[index];
      final Execution? nextExecution =
          index + 1 < _pendingTasks.length ? _pendingTasks[index + 1] : null;
      final Execution? previousExecution =
          index - 1 >= 0 ? _pendingTasks[index - 1] : null;

      if (cancelRequested) {
        break;
      }

      if (nextExecution?.type == ExecutionType.stopAfter ||
          nextExecution?.type == ExecutionType.executeAfter || nextExecution?.type == ExecutionType.then) {
        await execution.function();
      } else {
        execution.function();
        // Execution(
        //   function: () async {
        //     await Future.delayed(duration);
        //   },
        //   type: ExecutionType.delay,
        // );

        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     transitionDuration: const Duration(milliseconds: 500),
        //     reverseTransitionDuration: const Duration(milliseconds: 500),
        //     pageBuilder: (context, animation, secondaryAnimation) {
        //       final Animation<Offset> anim = Tween<Offset>(
        //         begin: const Offset(0, -1),
        //         end: Offset.zero,
        //       )
        //           .chain(CurveTween(curve: Curves.easeOutSine))
        //           .animate(animation);
        //       return SlideTransition(
        //         position: anim,
        //         child: const Page1(),
        //       );
        //     },
        //   ),
        // );
      }
    }
    OnFinish;
  }

  // Stream<Event> get onFinish => finishEvent.forTarget(this);

  // Future<void> onFinish(BuildContext context) async{
  //   Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 500),
  //       reverseTransitionDuration: const Duration(milliseconds: 500),
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         final Animation<Offset> anim = Tween<Offset>(
  //           begin: const Offset(0, -1),
  //           end: Offset.zero,
  //         )
  //             .chain(CurveTween(curve: Curves.easeOutSine))
  //             .animate(animation);
  //         return SlideTransition(
  //           position: anim,
  //           child: const Page1(),
  //         );
  //       },
  //     ),
  //   );
  // }

}

class Execution {
  Execution({required this.function, required this.type});

  final Function() function;
  final ExecutionType type;
}

enum ExecutionType {
  execute,
  executeAfter,
  stop,
  stopAfter,
  delay,
  flush,
  then,
}

typedef FutureCallBack =  Function();

abstract class CallbackFunction {
  final FutureCallBack onFinish;
  CallbackFunction({required this.onFinish});
}

abstract class OnFinish extends CallbackFunction {
  OnFinish({required super.onFinish});
}