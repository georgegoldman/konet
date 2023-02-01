import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/verification.dart';

class AddServiceService extends BaseService with AppNotifier {
  final BuildContext context;
  AddServiceService({required this.context});

  Future<void> addServiceRequest() async {
    try {
      List allAddedService =
          Provider.of<AddServiceManipulator>(context, listen: false)
              .addedService;
      Map<String, dynamic> body = {"services": allAddedService};
      http.StreamedResponse response = await patchWithJson(
          'https://curnect.com/curnect-api/public/api/registerservice', body);
      // for (var i in allAddedService) {
      //   final response = await user.addService(
      //       i, 'https://curnect.com/curnect-api/public/api/registerservice');
      //   allRequest.add(response);
      // }
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context)
              .push(RouteAnimation(Screen: const Verification()).createRoute());
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
      print(e);
      return;
    }
  }
}
