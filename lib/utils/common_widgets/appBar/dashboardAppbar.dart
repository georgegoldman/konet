import 'package:flutter/material.dart';

mixin ApplicationBar<T extends StatefulWidget> on State<T> {
  AppBar dashboardAppbar() {
    return AppBar(
      backgroundColor: Colors.black,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.black,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.list_rounded,
              color: Colors.white60,
            )),
        IconButton(
            onPressed: () => print('notification'),
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white60,
            )),
        IconButton(
            onPressed: () => print('nothing was added here'),
            icon: const Icon(
              Icons.question_mark,
              color: Colors.white60,
            ))
      ],
      leading: IconButton(
        onPressed: () => print('profile photo'),
        icon: const Icon(
          Icons.person_outline_rounded,
          color: Colors.white60,
        ),
      ),
    );
  }
}
