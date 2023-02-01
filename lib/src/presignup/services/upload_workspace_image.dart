import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/add_service.dart';

class UploadWorkPictureService extends BaseService with AppNotifier {
  final BuildContext context;
  UploadWorkPictureService({required this.context});

  Future<void> uploadImageRequest(
    CroppedFile? croppedFile,
    XFile? pickedFile,
  ) async {
    try {
      String userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id']
          .toString();
      Map<String, String> data = {"_method": "patch", "id": userId};
      if (croppedFile != null) {
        StreamedResponse response = await patchWithImage(croppedFile.path, data,
            'https://curnect.com/curnect-api/public/api/registerbusinessimage');
        Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context)
                .push(RouteAnimation(Screen: AddService()).createRoute());
            return;
          } else {
            errorSnackBar(context, json.decode(res.body));
            return;
          }
        });
      } else {
        StreamedResponse response = await patchWithImage(pickedFile!.path, data,
            'https://curnect.com/curnect-api/public/api/registerbusinessimage');
        Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context)
                .push(RouteAnimation(Screen: AddService()).createRoute());
            return;
          } else {
            errorSnackBar(context, json.decode(res.body));
            return;
          }
        });
      }
    } on SocketException catch (e) {
      errorSnackBar(context, e.message);
      return;
    } catch (e) {
      print(e);
      return;
    }
  }
}
