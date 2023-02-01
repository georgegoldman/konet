import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/fetch_g_address.dart';

class HowToLocateService extends BaseService with AppNotifier {
  final BuildContext context;
  HowToLocateService({required this.context});

  Future<void> howTolocateYouRequest(Map<String, String> body) async {
    try {
      String userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id']
          .toString();
      body["userid"] = userId;

      final response = await patchForFormDate(body,
          "https://curnect.com/curnect-api/public/api/registerservicelocation");
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const SearchPlacesScreen()).createRoute());
          return;
        } else {
          errorSnackBar(context, json.decode(res.body));
          return;
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message);
      return;
    } catch (e) {
      print(e);
      return;
    }
  }
}
