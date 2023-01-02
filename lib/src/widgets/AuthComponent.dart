// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AuthLogoImage extends StatelessWidget {
  const AuthLogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: (() => Navigator.of(context).pop()),
          child: const Icon(
            Icons.arrow_circle_left_outlined,
            size: 27,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.0),
          child: Image.asset(
            'assets/images/curnect_logo_blackcurnect_logo.png',
            width: 120,
          ),
        ),
        IconButton(
            onPressed: () => _dialogBuilder(context),
            icon: const Icon(Icons.info_outline_rounded, size: 27))
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Info on Verification"),
            content: SingleChildScrollView(
              child: Text(
                  "The data you share will be encrypted, stored\nsecurely, and only used to verify your identity"),
            ),
          );
        });
  }
}
