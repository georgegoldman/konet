import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseService {
  BaseService();

  Future<http.StreamedResponse> postForFormDate(
      Map<String, String> body, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<http.StreamedResponse> patchForFormDate(
      Map<String, String> body, String url) async {
    body['_method'] = 'patch';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);

    return await request.send();
  }

  Future<http.StreamedResponse> patchWithImage(filePath, url, body) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    request.files
        .add(await http.MultipartFile.fromPath(body['image_id'], filePath));

    return await request.send();
  }

  Future<http.StreamedResponse> patchWithJson(
      String url, Map<String, dynamic> body) async {
    final headers = {'Content-Type': 'application/json'};
    final request = http.Request('POST', Uri.parse(url));
    body["_method"] = "patch";
    request.body = json.encode(body);
    request.headers.addAll(headers);

    return await request.send();
  }
}
