import 'package:flutter/material.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/onboarding/mobile_onboarding_one.png'),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              const Text(
                'We are better\ntogether.',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Booksy delivers business owners 24/7 self-service\ncustomer bookings, business management tools\n, and a built-in marketing suite. You focus on your skills\n,we’ll do the rest.',
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
