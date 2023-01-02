// ignore_for_file: unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';

class RouteAnimation {
  final Widget Screen;

  RouteAnimation({
    required this.Screen,
  });
  Route createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Screen,
        transitionDuration: const Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        });
  }
}
