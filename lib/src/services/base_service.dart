import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BaseService {
  BaseService();

  /// send a get request
  /// @param url Request URL
  /// @param conf Request configuration settings
  /// @returns {Promise.<*>}
  Future<http.Response> get(String url, Map<String, dynamic> conf) async {
    var getUrl = Uri.parse(url);
    return await http
        .get(getUrl, headers: {HttpHeaders.authorizationHeader: conf['token']});
  }

  ///send a post request
  ///@param url Request url
  ///@param body Request body
  ///@param conf Request configuration settings.
  ///@returns {Promise.<*>}
  Future<http.Response> post(String url, Map<String, dynamic> conf) async {
    var getUrl = Uri.parse(url);
    return await http.post(getUrl,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: conf['token']
        },
        body: conf);
  }

  Future<http.Response> patch(String url, dynamic conf) async {
    var getUri = Uri.parse(url);
    return await http.patch(getUri,
        headers: {HttpHeaders.authorizationHeader: conf['token']}, body: conf);
  }

  Future<http.StreamedResponse> checkResetPasswordEmail(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<http.StreamedResponse> ResetPincode(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<Map<String, dynamic>> ResetTonewPasswordAPI(body, url) async {
    print("body");
    print(body);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    http.StreamedResponse response = await request.send();
    return http.Response.fromStream(response).then((value) {
      print(value.body);
      if (value.statusCode == 202) {
        return {
          "statusCode": value.statusCode,
          "userId": json.decode(value.body)
        };
      } else {
        return {"error": value.reasonPhrase};
      }
    });
  }

  Future<Map<String, dynamic>> businessHourResponse(
      String url, Map<String, dynamic> body) async {
    body["_method"] = "patch";
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 202) {
      return http.Response.fromStream(response).then((value) {
        return {
          "statusCode": value.statusCode,
          "successful": true,
          "body": value.body
        };
      });
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> patchWithJson(
      String url, Map<String, dynamic> body) async {
    print("getting here");
    final headers = {'Content-Type': 'application/json'};
    final request = http.Request('POST', Uri.parse(url));
    body["_method"] = "patch";
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 202) {
      return http.Response.fromStream(response).then((value) {
        return {"statusCode": response.statusCode, "body": value.body};
      });
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future<http.Response> delete(String url, Map<String, dynamic> conf) async {
    var getUri = Uri.parse(url);
    return await http
        .put(getUri, headers: {HttpHeaders.authorizationHeader: conf['token']});
  }

  Future<http.StreamedResponse> patchWithImage(filePath, data, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll((data));
    request.files
        .add(await http.MultipartFile.fromPath('business_image', filePath));
    return await request.send();
  }

  Future<http.StreamedResponse> addServiceAPi(body, url) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send();
    return res;
  }

  Future<http.StreamedResponse> idVerification(filePath, url, body) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    request.files.add(await http.MultipartFile.fromPath('id_image', filePath));

    final res = await request.send();
    return res;
  }

  Future<http.StreamedResponse> verifyAddredss(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<http.StreamedResponse> publishProfile(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<http.StreamedResponse> registration(url, body) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<Map<String, dynamic>> locateUserService(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    http.StreamedResponse response = await request.send();

    return http.Response.fromStream(response).then((value) {
      if (value.statusCode == 202) {
        return {
          "statusCode": value.statusCode,
          "body": json.encode(value.body)
        };
      } else {
        return {"Error": value.reasonPhrase};
      }
    });
  }

  Future<Map<String, dynamic>> homeServiceBaseAPI(body, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    print(body);
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();

    return http.Response.fromStream(response).then((value) {
      if (value.statusCode == 202) {
        return {"statusCode": value.statusCode, "body": value};
      } else {
        print(value.body);
        return {"Error": value.reasonPhrase};
      }
    });
  }
}
