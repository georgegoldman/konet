import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController _controller;

  @override
  void initState() {
    _controller = GifController(vsync: this);
    super.initState();
    // Future.delayed(
    //   const Duration(seconds: 10),
    // ).whenComplete(() {
    //   if (_controller.isCompleted) {
    //     ;
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Gif(
                image: const AssetImage(
                    'assets/images/curnect_lanim_b_alpha_noloop.gif'),
                controller: _controller,
                autostart: Autostart.no,
                onFetchCompleted: () {
                  _controller.reset();
                  _controller
                      .forward()
                      .whenComplete(() => context.replace('/onboarding'));
                },
              ),
            ),
          ),
        ));
  }
}
