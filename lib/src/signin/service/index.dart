// ignore_for_file: use_build_context_synchronously

import 'package:curnect/utils/user/sevice/index.dart';
import 'package:flutter/material.dart';

class SigninService extends User {
  @override
  final BuildContext context;
  SigninService({required this.context}) : super(context: context);

  Future<void> signInUser(
    String email,
    String password,
  ) =>
      signInRequest(email, password);
}
