// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SlideInAnimation extends CustomTransitionPage<void> {
  final Cubic easeIn = const Cubic(0.42, 0.0, 1.0, 1.0);
  SlideInAnimation({super.key, required super.child})
      : super(
            transitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: animation.drive(Tween(
                  begin: const Offset(5, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn))),
                child: child,
              );
            });
}
