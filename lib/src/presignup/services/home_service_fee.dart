import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/business_hours.dart';

class HomeServiceService extends BaseService with AppNotifier {
  final BuildContext context;
  HomeServiceService({required this.context});

  Future<void> homeServiceAPI(Map<String, String> body) async {
    try {
      int userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id'];
      body['userid'] = userId.toString();

      http.StreamedResponse response = await patchForFormDate(body,
          'https://curnect.com/curnect-api/public/api/registerhomeservicefee');
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const BusinessHours()).createRoute());
          return;
        } else {
          errorSnackBar(context, json.decode(res.body)['error']);
          return;
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message);
      return;
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
