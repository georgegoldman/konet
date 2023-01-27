// ignore_for_file: use_build_context_synchronously, overridden_fields, annotate_overrides

import 'package:curnect/utils/user/sevice/index.dart';
import 'package:flutter/material.dart';

class SigninService extends UserService {
  final BuildContext context;
  SigninService({required this.context}) : super(context: context);

  Future<void> signInUser(
    String email,
    String password,
  ) =>
      signInRequest(email, password);
}
