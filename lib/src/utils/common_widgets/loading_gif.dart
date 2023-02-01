// ignore: duplicate_ignore
// ignore: implementation_imports
// ignore_for_file: implementation_imports

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPageGif extends StatefulWidget {
  const LoadingPageGif({super.key});

  @override
  State<LoadingPageGif> createState() => _LoadingPageGifState();
}

class _LoadingPageGifState extends State<LoadingPageGif>
    with TickerProviderStateMixin {
  late AnimationController _loadingPage;

  @override
  void initState() {
    super.initState();
    _loadingPage = AnimationController(vsync: this);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _loadingPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(120, 0, 0, 0),
        child: Center(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: Lottie.asset(
              'assets/images/curnect_load_anim.json',
              controller: _loadingPage,
              onLoaded: (composite) {
                _loadingPage
                  ..duration = composite.duration
                  ..forward();
              },
              height: 120,
              width: 120,
            ),
          ),
        )));
  }
}
