import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../routes/route_animation.dart';
import '../../utils/state/add_service_manipulator.dart';
import '../screens/howToLocateYou.dart';

class SelectCategoryService extends BaseService with AppNotifier {
  final BuildContext context;
  SelectCategoryService({required this.context});

  Future<void> selectCategoryRequest(
    Map<String, int> categoryMap,
    List<String> selected,
  ) async {
    try {
      String userId = Provider.of<AddServiceManipulator>(context, listen: false)
          .user['user_id']
          .toString();
      print(userId);
      late List<Map<String, int>> businessCategoryArray = [];
      Map<String, dynamic> body = {};
      //iterate through the list of category
      for (var x in categoryMap.keys) {
        for (var element in selected) {
          // get selectd aervices
          if (element == x) {
            // add the selected service to list
            businessCategoryArray.add({
              "business_category": categoryMap[x]!.toInt(),
              "user_id": int.parse(userId)
            });
          }
        }
      }
      body["businesscat"] = businessCategoryArray;
      if (businessCategoryArray.isNotEmpty) {
        final response = await patchWithJson(
            'https://curnect.com/curnect-api/public/api/registerbusinesscategory',
            body);
        Response.fromStream(response).then((res) {
          if (res.statusCode == 202) {
            Navigator.of(context).push(
                RouteAnimation(Screen: const HowToLocateYou()).createRoute());
            return;
          } else {
            errorSnackBar(context, json.decode(res.body));
            return;
          }
        });
      } else {
        infoSnackBar(context, 'Please select an item');
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
