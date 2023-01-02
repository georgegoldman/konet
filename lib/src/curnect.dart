import 'package:curnect/src/routes/Router.dart';
import 'package:curnect/src/state_manager/add_service_manipulator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Curnect extends StatelessWidget {
  Curnect({Key? key}) : super(key: key);

  static const String title = 'Curnect';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AddServiceManipulator(),
        child: MaterialApp.router(
          routerConfig: _route,
          // title: title,
          debugShowCheckedModeBanner: false,
        ));
  }

  final GoRouter _route = Routing().router;
}
