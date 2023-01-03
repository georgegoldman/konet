import 'dart:convert';

import 'package:curnect/src/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class User extends BaseService {
  late String email;
  late String password;
  late String? fullName;
  late String? businessName;
  late String? phone;
  late String? referralCode;
  late String? token;
  late bool? logIn;
  late int? id;
  User(
      {required this.email,
      required this.password,
      this.fullName,
      this.businessName,
      this.phone,
      this.referralCode,
      this.logIn,
      this.id,
      this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['success']['token'].toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      fullName: json['full_name'].toString(),
      businessName: json['business_name'].toString(),
      phone: json['phone_number'].toString(),
      id: json['success']['userId'],
    );
  }

  Future<Response> login(url, conf) async {
    final response = await this.post(url, conf);
    return response;
  }

  Future<Response> checkEmail(url, conf) async {
    final response = await this.post(url, conf);

    return response;
  }

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
