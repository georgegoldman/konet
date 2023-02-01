// ignore_for_file: annotate_overrides, overridden_fields

import 'package:curnect/src/utils/user/sevice/index.dart';
import 'package:flutter/cupertino.dart';

class SignupService extends UserService {
  final BuildContext context;
  SignupService({required this.context}) : super(context: context);

  Future<void> checkUserEmail(String email, String url) =>
      checkEmail(email, url);

  Future<void> signUpUserAccount(Map<String, String> body, String url) =>
      signUpRequest(body, url, context);
}
