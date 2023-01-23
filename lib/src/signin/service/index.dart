// ignore_for_file: use_build_context_synchronously

import 'package:curnect/utils/user.dart';
import 'package:flutter/material.dart';

class SigninService extends User {
  SigninService();

  Future<void> signInUser(
          String email, String password, BuildContext context) =>
      signInRequest(email, password, context);
}
