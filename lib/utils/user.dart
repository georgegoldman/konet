// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:curnect/utils/base_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:curnect/src/common_widgets/appNotifier/index.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../src/routes/route_animation.dart';
import '../src/signup/screens/SignupTwo.dart';
import '../src/state_manager/add_service_manipulator.dart';

class User extends BaseService with AppNotifier {
  User();

  Future<void> signInRequest(
      String email, String password, BuildContext context) async {
    try {
      final response = await postForFormDate(
        {"email": email, "password": password, "token": ''},
        'https://curnect.com/curnect-api/public/api/login',
      );
      http.Response.fromStream(response).then((res) {
        if (response.statusCode == 200) {
          Provider.of<AddServiceManipulator>(context, listen: false).loginUser({
            'user_token': json.decode(res.body)['token'],
            'user_id': json.decode(res.body)['success']['userId'],
            'loggedIn': response.statusCode,
          });
          context.replace('/calendar');
          return;
        } else {
          errorSnackBar(context, json.decode(res.body)['error'].toString());
          return;
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message.toString());
      return;
    } on NoSuchMethodError catch (e) {
      errorSnackBar(context, e.toString());
      return;
    } catch (e) {
      errorSnackBar(context, 'Opps something went wrong but not your fault');
      return;
    }
  }

  Future<void> checkEmail(
      String email, String url, BuildContext context) async {
    try {
      final response = await postForFormDate(
        {'email': email},
        'https://curnect.com/curnect-api/public/api/checkemail',
      );
      if (response.statusCode == 200) {
        context.replace('/signin');
        return;
      } else {
        Navigator.of(context).push(RouteAnimation(
            Screen: SignupPageTwo(
          email: email,
        )).createRoute());
        return;
      }
    } on SocketException catch (e) {
      errorSnackBar(context, e.message.toString());
    } catch (e) {
      return;
    }
  }

  Future<void> signOutUser() async {}

  Future<Response> login(url, conf) async {
    final response = await this.post(url, conf);
    return response;
  }

  // Future<Response> checkEmail(url, conf) async {
  //   final response = await this.post(url, conf);

  //   return response;
  // }

  Future<http.StreamedResponse> homeServiceAPIFunction(body, url) async {
    return await homeServiceBaseAPI(body, url);
  }

  Future<http.StreamedResponse> checkResetPasswordEmailAPI(body, url) async {
    return await checkResetPasswordEmail(body, url);
  }

  Future<http.StreamedResponse> checkResetPasswordPincodeAPI(body, url) async {
    return await ResetPincode(body, url);
  }

  Future<Map<String, dynamic>> resetToNewPassword(body, url) async {
    try {
      return await ResetTonewPasswordAPI(body, url);
    } catch (e) {
      return {"error": e};
    }
  }

  Future<bool> validateAddress(url, conf) async {
    final response = await this.post(url, conf);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // debugPrint('it not working');
      return true;
    }
  }

  Future<http.StreamedResponse> businessHour(url, conf) async {
    return await businessHourResponse(url, conf);
  }

  Future<Map<String, dynamic>> registerService(url, conf) async {
    final response = await this.post(url, conf);
    if (response.statusCode == 202) {
      return {
        'successful': true,
        'res': response.body.toString(),
        'errorCode': response.statusCode
      };
    } else {
      return {
        'successful': false,
        'res': response.body.toString(),
        'errorCode': response.statusCode
      };
    }
  }

  Future<http.StreamedResponse> uploadImage(filePath, data, url) async {
    return await patchWithImage(filePath, data, url);
  }

  Future<http.StreamedResponse> addService(body, url) async {
    return await addServiceAPi(body, url);
  }

  Future<http.StreamedResponse> register(url, conf) async {
    final response = await registration(url, conf);
    return response;
  }

  Future<http.StreamedResponse> idVerificationController(
      filePath, body, url) async {
    return await idVerification(filePath, url, body);
  }

  Future<http.StreamedResponse> validateAddressController(body, url) async {
    return await verifyAddredss(body, url);
  }

  Future<bool> publishProfileController(body, url) async {
    final response = await publishProfile(body, url);
    if (response.statusCode == 202) {
      return true;
    } else {
      return true;
    }
  }

  Future<http.StreamedResponse> locateUser(body, url) async {
    return await locateUserService(body, url);
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
