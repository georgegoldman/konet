// ignore_for_file: use_build_context_synchronously

import '../../state_manager/add_service_manipulator.dart';

class SigninService with AppNotifier {
  SigninService();

  Future<void> loginRequest(
      String email, String password, BuildContext context) async {
    // final userToken = getUserToken();
  }
}
