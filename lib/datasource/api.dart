import 'dart:convert';
import 'dart:developer';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tyrasoft_attendance/exception/api_exception.dart';
import 'package:tyrasoft_attendance/model/web_url_data.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';
import 'package:http/http.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  static Map<String, dynamic> toJson(LoginRequest data) {
    final Map<String, dynamic> request = {
      'jsonrpc': '2.0',
      'params': {
        "db": "laysander_240911",
        "login": data.email,
        "password": data.password
      }
    };

    return request;
  }
}

class Api {
  final String baseUrl;

  Future<List<WebUrlData>> getUrl() async {
    try {
      var response = await get(Uri.https(baseUrl, "get_mobile_api"));
      log(response.body);
      var data = MobileApiResponse.fromJson(jsonDecode(response.body));

      return data.data
          .map((e) =>
              WebUrlData(id: e.id ?? 0, name: e.name ?? "", url: e.link ?? ""))
          .toList();
    } catch (e) {
      throw ApiEexception(e.toString());
    }
  }

  Future<String> login(LoginRequest request) async {
    try {
      final uri = Uri.https(baseUrl, 'web/session/authenticate');

      var response = await post(
        uri,
        body: jsonEncode(
          LoginRequest.toJson(request),
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final setCookieHeader = response.headers['set-cookie'];

      final Map<String, dynamic> responseHeaderCookie = {};

      if (setCookieHeader == null) {
        throw ApiEexception('No Set-Cookie Header');
      }

      print(setCookieHeader);

      final cookies = setCookieHeader.split(';');
      for (final cookie in cookies) {
        final parts = cookie.trim().split('=');
        final name = parts[0];
        final value = parts.length > 1 ? parts[1] : '';

        // Handle the cookie as needed (e.g., store it, use it for subsequent requests)

        responseHeaderCookie[name] = value;
      }

      return responseHeaderCookie['session_id'];
    } catch (e) {
      throw ApiEexception(e.toString());
    }
  }

  const Api({this.baseUrl = "erp.tyrasoft.com"});
}
