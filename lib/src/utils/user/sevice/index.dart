// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:curnect/src/utils/backend_service_api/base_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:curnect/src/utils/common_widgets/appNotifier/index.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/route_animation.dart';
import '../../../signup/screens/SignupTwo.dart';
import '../../state/add_service_manipulator.dart';

class UserService extends BaseService with AppNotifier {
  BuildContext context;
  UserService({required this.context});

  Future<void> signInRequest(
    String email,
    String password,
  ) async {
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
    String email,
    String url,
  ) async {
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

  Future<void> checkResetPasswordEmailAPI(
    String email,
  ) async {
    try {
      final response = await postForFormDate({"email": email},
          'https://curnect.com/curnect-api/public/api/checkforgetemail');
      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 200) {
          context.push('/getyourcode', extra: {
            "email": email,
            "userId": json.decode(res.body)["userid"]
          });
        } else {
          errorSnackBar(context, 'check email');
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message);
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> resetPin(String email) async {
    try {
      await postForFormDate({'email': email},
          'https://curnect.com/curnect-api/public/api/checkforgetemail');
      successSnackBar(context, 'Pin reset successful');
      return;
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> ResetTonewPasswordAPI(body) async {
    var response = await patchForFormDate(
        body, "https://curnect.com/curnect-api/public/api/changepassword");

    return http.Response.fromStream(response).then((value) {
      if (value.statusCode == 202) {
        context.pop();
        context.pop();
        context.replace('/signin');
        return;
      } else {
        errorSnackBar(context, value.reasonPhrase.toString());
        return;
      }
    });
  }

  Future<void> pinCodeAPIService(Map<String, String> body) async {
    try {
      var response = await patchForFormDate(
          body, 'https://curnect.com/curnect-api/public/api/checktoken');

      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 202) {
          context.push('/resetpasword', extra: {"userId": body["userid"]});
        } else {
          switch (res.statusCode) {
            case 401:
              errorSnackBar(context, 'Please check your pin');
              return;
            case 500:
              errorSnackBar(
                  context, "An Error occured but it is not your fault");
              return;
            default:
              errorSnackBar(context, 'Please check your pin');
              return;
          }
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message.toString());
      return;
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> signUpRequest(
      Map<String, String> body, String url, BuildContext context) async {
    try {
      var response = await postForFormDate(
        body,
        url,
      );

      http.Response.fromStream(response).then((res) {
        if (res.statusCode == 201) {
          Provider.of<AddServiceManipulator>(context, listen: false).loginUser({
            'user_token': json.decode(res.body)['success']['token'],
            'user_id': json.decode(res.body)['success']['token'],
          });
          context.replace('/verify');
        } else {
          errorSnackBar(context, 'The email has already been taken.');
          return;
        }
      });
    } on SocketException catch (e) {
      errorSnackBar(context, e.message.toString());
    } catch (e) {
      errorSnackBar(context, 'Opps... not your fault');
    }
  }

  Future<void> signOutUser() async {}

  // Future<Response> login(url, conf) async {
  //   final response = await this.post(url, conf);
  //   return response;
  // }

  // Future<Response> checkEmail(url, conf) async {
  //   final response = await this.post(url, conf);

  //   return response;
  // }
}
