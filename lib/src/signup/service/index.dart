import 'package:curnect/utils/user.dart';
import 'package:flutter/cupertino.dart';

class SignupService extends User {
  SignupService();

  Future<void> checkUserEmail(String email, String url, BuildContext context) =>
      checkEmail(email, url, context);
}
