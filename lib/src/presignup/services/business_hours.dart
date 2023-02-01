import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/upload_workspace_image.dart';

class BusinessHourService extends BaseService with AppNotifier {
  final BuildContext context;

  BusinessHourService({required this.context});

  List<Map<String, dynamic>> businessHours = [];

  Future<void> businessHourRequest(
      Map<String, Map<String, dynamic>> days) async {
    Map<String, dynamic> body = {};
    int userId = Provider.of<AddServiceManipulator>(context, listen: false)
        .user['user_id'];
    // String token = Provider.of<AddServiceManipulator>(context, listen: false)
    //     .user['user_token'];
    for (var day in days.keys) {
      businessHours.add({
        "user_id": userId,
        "days": day,
        "availability": days[day]!['on'],
        "start_time":
            "${days[day]!['starttime'].hour.toString().padLeft(2, '0')}:${days[day]!['starttime'].minute.toString().padLeft(2, '0')}"
                .toString(),
        "end_time":
            "${days[day]!['endtime'].hour.toString().padLeft(2, '0')}:${days[day]!['endtime'].minute.toString().padLeft(2, '0')}" ==
                    "24:00"
                ? "00:00"
                : "${days[day]!['endtime'].hour.toString().padLeft(2, '0')}:${days[day]!['endtime'].minute.toString().padLeft(2, '0')}",
      });
    }
    try {
      body["businessHours"] = businessHours;
      http.StreamedResponse response = await patchWithJson(
          'https://curnect.com/curnect-api/public/api/registerbusinesshour',
          body);

      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          Navigator.of(context).push(
              RouteAnimation(Screen: const UploadWorkspaceImage())
                  .createRoute());
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
    // debugPrint(response.toString());
  }
}
