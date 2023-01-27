// ignore_for_file: overridden_fields

import 'package:curnect/utils/user/sevice/index.dart';
import 'package:flutter/cupertino.dart';

class SignupService extends User {
  @override
  final BuildContext context;
  SignupService({required this.context}) : super(context: context);

  Future<void> checkUserEmail(String email, String url) =>
      checkEmail(email, url);

  Future<void> signUpUserAccount(Map<String, String> body, String url) =>
      signUpRequest(body, url, context);
}
