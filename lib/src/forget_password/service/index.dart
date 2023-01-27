// ignore_for_file: overridden_fields

import 'package:curnect/utils/user/sevice/index.dart';
import 'package:flutter/cupertino.dart';

class ResetPasswordService extends UserService {
  @override
  final BuildContext context;
  ResetPasswordService({required this.context}) : super(context: context);

  Future<void> checkResetEmail(email) => checkResetPasswordEmailAPI(email);

  Future<void> pinCodeReset(Map<String, String> body) =>
      pinCodeAPIService(body);

  Future<void> resetPinService(String email) => resetPin(email);

  Future<void> resetPasswordService(Map<String, String> body) =>
      ResetTonewPasswordAPI(body);
}
