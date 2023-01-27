import 'package:curnect/utils/user/sevice/index.dart';
import 'package:flutter/cupertino.dart';

class SignupService extends User {
  SignupService();

  Future<void> checkUserEmail(String email, String url, BuildContext context) =>
      checkEmail(email, url, context);

  Future<void> signUpUserAccount(
          Map<String, String> body, String url, BuildContext context) =>
      signUpRequest(body, url, context);
}
