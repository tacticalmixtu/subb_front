import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:subb_front/models/api_response.dart';

const domainName = 'smalltalknow.com';

final _client = http.Client();

Future<String?> getCookies() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('COOKIES') ?? null;
}

Future<void> setCookies(String cookies) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('COOKIES', cookies);
}

Future<ApiResponse?> doGet(
    String path, Map<String, dynamic>? queryParams) async {
  final uri = Uri.https(domainName, path, queryParams);

  try {
    final cookies = await getCookies();
    final response = cookies != null
        ? await _client.get(uri, headers: {HttpHeaders.cookieHeader: cookies})
        : await _client.get(uri);

    if (response.statusCode == 200) {
      return await compute(parseApiResponse, response.body);
    }
  } catch (e, s) {
    print('Exception caught in doGet(): $e');
    print('Stack trace:\n $s');
    return null;
  }
}

Future<ApiResponse?> doPost(
    String path, Map<String, dynamic> queryParams, Object? body) async {
  final uri = Uri.https(domainName, path, queryParams);
  try {
    final cookies = await getCookies();
    final response = cookies != null
        ? await _client.post(uri,
            headers: {HttpHeaders.cookieHeader: cookies}, body: body)
        : await _client.post(uri,
            // headers: {
            //   HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            // },
            body: body);
    if (response.statusCode == 200) {
      if (response.headers[HttpHeaders.setCookieHeader] != null) {
        await setCookies(response.headers[HttpHeaders.setCookieHeader]!);
        print('cookie set!: ${response.headers[HttpHeaders.setCookieHeader]}');
      }
      return await compute(parseApiResponse, response.body);
    }
  } catch (e, s) {
    print('exception caught in doGet():');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
    return null;
  }
}
