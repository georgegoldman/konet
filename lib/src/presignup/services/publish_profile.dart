import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/presignup/screens/hurray.dart';
import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';

class PublishService extends BaseService with AppNotifier {
  final BuildContext context;
  PublishService({required this.context});

  Future<void> publishProfile(Map<String, String> body) async {
    try {
      int userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id'];
      body['userId'] = userId.toString();

      http.StreamedResponse response = await patchForFormDate(body,
          'https://curnect.com/curnect-api/public/api/registerdatetogolive');
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context)
              .push(RouteAnimation(Screen: Hurray()).createRoute());
          return;
        } else {
          errorSnackBar(context, json.decode(res.body));
          return;
        }
      });
      return;
    } on SocketException catch (e) {
      errorSnackBar(context, e.message);
    } catch (e) {
      print(e);
      return;
    }
  }
}
