import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/response-model.dart';

String domain = 'https://api.quickfoodmm.com/api/v1';
String username = '';
String accesstoken = '';
String refreshtoken = '';
bool loginFlat = false;

class APIService {
  static final APIService _instance = APIService.internal();
  APIService.internal();
  factory APIService() => _instance;

  final JsonDecoder _decoder = const JsonDecoder();

  Future<ResponseModel> token(String url,
      {required Map<String, String> body, encoding}) async {
    return await http
        .post(Uri.parse("$domain/$url"),
            body: body,
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            encoding: encoding)
        .then((http.Response response) {
      return ResponseModel.fromJson(_decoder.convert(response.body));
    }).catchError((e) {
      return e;
    });
  }

  Future<String> getauthorized(String url) async {
    return await http.get(
      "http://$url" as Uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      },
    ).then((http.Response response) {
      final String res = response.body;
      return res;
    // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  Future<int> postauthorizedv1(String url, {required Map body}) async {
    try {
      return http
          .post("http://$url" as Uri,
              headers: <String, String>{
                'Content-Type': 'application/x-www-form-urlencoded',
                'Authorization': 'Bearer $accesstoken',
              },
              body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        return statusCode;
      });
    } catch (e) {
      return 500;
    }
  }

  Future<int> postauthorizedv2(String url, {required Map body}) async {
    try {
      return http
          .post("http://$url" as Uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accesstoken',
              },
              body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400) {
          return statusCode;
        }
        return statusCode;
      });
    } catch (e) {
      return 500;
    }
  }

  Future<http.Response?> postauthorizedv3(String url,
      {required Map body}) async {
    try {
      return http
          .post("http://$url" as Uri,
              headers: <String, String>{
                'Content-Type': 'application/x-www-form-urlencoded',
                'Authorization': 'Bearer $accesstoken',
              },
              body: body)
          .then((http.Response response) => response);
    } catch (e) {
      return null;
    }
  }
}
