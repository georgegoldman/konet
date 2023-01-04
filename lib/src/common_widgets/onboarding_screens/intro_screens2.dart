import 'package:flutter/material.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/onboarding/mobile_onboarding_two.png'),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              const Text(
                'Every moment\nspent with us\nis worth it.',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const Text(
                'With built in payment solutions, No-Show Protection, and\npowerful tools to help you keep your calendar full, Curnect\nhelps you grow your bottom line.',
                style: TextStyle(color: Colors.white, fontSize: 11),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
