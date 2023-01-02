import 'dart:convert';

import 'package:curnect/src/customException/unsuccessfulRequestException.dart';
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

  Future<Map<String, dynamic>> checkEmail(url, conf) async {
    try {
      final response = await this.post(url, conf);

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
        };
      } else {
        // print("getting to the exception");
        throw UnsuccessfulRequestException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> homeServiceAPIFunction(body, url) async {
    try {
      return await homeServiceBaseAPI(body, url);
    } catch (e) {
      return {"error": e};
    }
  }

  Future<Map<String, dynamic>> checkResetPasswordEmailAPI(body, url) async {
    try {
      return await checkResetPasswordEmail(body, url);
    } catch (e) {
      return {"error": e};
    }
  }

  Future<Map<String, dynamic>> checkResetPasswordPincodeAPI(body, url) async {
    try {
      return await ResetPincode(body, url);
    } catch (e) {
      return {"error": e};
    }
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

  Future<Map<String, dynamic>> businessHour(url, conf) async {
    try {
      final response = await businessHourResponse(url, conf);

      return response;
    } catch (e) {
      return {"error": e};
    }
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

  Future<bool> uploadImage(filePath, data, url) async {
    final response = await patchWithImage(filePath, data, url);
    if (response.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> addService(body, url) async {
    final response = await addServiceAPi(body, url);
    final res = http.Response.fromStream(response).then((res) {
      if (res.statusCode == 202) {
        return {
          'successful': true,
          'res': json.decode(res.body),
        };
      } else {
        throw Exception(response.statusCode.toString());
      }
    });
    return res;
  }

  Future<Map<String, dynamic>> register(url, conf) async {
    final response = await registration(url, conf);
    final res = http.Response.fromStream(response).then((res) {
      if (res.statusCode == 201) {
        return {
          'token': User.fromJson(jsonDecode(res.body)).token,
          'signUpSuccessfull': true,
          'id': User.fromJson(jsonDecode(res.body)).id
        };
      } else {
        throw Exception(response.statusCode.toString());
      }
    });
    return res;
  }

  Future<Map<String, dynamic>> idVerificationController(
      filePath, body, url) async {
    if (body['id_name'] == "Select Id type") {
      return {"resCode": 406};
    } else {
      final response = await idVerification(filePath, url, body);
      final resData = http.Response.fromStream(response).then((value) {
        if (value.statusCode == 202) {
          return {"resCode": value.statusCode, "msg": value.reasonPhrase};
        } else {
          throw Exception("${value.reasonPhrase}");
        }
      });
      return resData;
    }
  }

  Future<bool> validateAddressController(body, url) async {
    final response = await verifyAddredss(body, url);
    if (response.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> publishProfileController(body, url) async {
    final response = await publishProfile(body, url);
    if (response.statusCode == 202) {
      return true;
    } else {
      return true;
    }
  }

  Future<Map<String, dynamic>> locateUser(body, url) async {
    print(body);
    try {
      return await locateUserService(body, url);
    } catch (e) {
      return {"error": "$e"};
    }
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
