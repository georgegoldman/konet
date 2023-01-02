import 'package:flutter/material.dart';

class UnauthenticatedAppBar {
  final BuildContext context;
  final String screeenInfo;

  const UnauthenticatedAppBar(
      {required this.context, required this.screeenInfo});

  AppBar preferredSize() => AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          'assets/images/curnect_logo_blackcurnect_logo.png',
          width: 120,
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        'Helper box',
                      ),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(child: Text(screeenInfo)),
                      ),
                    ),
                  ))
        ],
      );
}

AppBar initUnauthenticatedAppBar(context, screenInfo) => UnauthenticatedAppBar(
      context: context,
      screeenInfo: '',
    ).preferredSize();
