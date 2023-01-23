// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialMediaSignIn extends StatelessWidget {
  const SocialMediaSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => debugPrint('you just hit the google login button'),
          icon: SvgPicture.asset(
            'assets/images/google_login_icon.svg',
          ),
        ),
        IconButton(
          onPressed: () => debugPrint('you just hit the apple login button'),
          icon: SvgPicture.asset(
            'assets/images/apple_login_icon.svg',
          ),
        ),
      ],
    ));
  }
}
