import 'dart:convert';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/publish_profile.dart';

class VerificationService extends BaseService with AppNotifier {
  final BuildContext context;
  VerificationService({required this.context});

  Future<void> verificationFunc(
    Map<String, String> body,
    XFile? pickedFile,
    CroppedFile? croppedFile,
  ) async {
    try {
      int userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id'];
      body['id'] = userId.toString();

      if (croppedFile != null) {
        StreamedResponse response = await patchWithImage(croppedFile.path, body,
            'https://curnect.com/curnect-api/public/api/registerid');

        Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context).push(
                RouteAnimation(Screen: const PublishProfile()).createRoute());
            return;
          } else {
            errorSnackBar(context, json.decode(res.body)['error']);
            return;
          }
        });
      } else {
        StreamedResponse response = await patchWithImage(pickedFile!.path, body,
            'https://curnect.com/curnect-api/public/api/registerid');
        Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context).push(
                RouteAnimation(Screen: const PublishProfile()).createRoute());
            return;
          } else {
            errorSnackBar(context, json.decode(res.body)['error'].toString());
            return;
          }
        });
      }
    } catch (e) {
      print(e);
      return;
    }
  }
}
