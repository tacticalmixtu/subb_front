import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:subb_front/models/api_response.dart';

const domainName = 'smalltalknow.com';

// use shared_preferences plugin to store cookie
// Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.).
// Data may be persisted to disk asynchronously
// no guarantee that writes will be persisted to disk after returning, so this plugin must not be used for storing critical data.

String? _cookie;
final _client = http.Client();

Future<ApiResponse?> doGet(
    String path, Map<String, dynamic>? queryParams) async {
  final uri = Uri.https(domainName, path, queryParams);

  try {
    final response = _cookie != null
        ? await _client.get(uri, headers: {HttpHeaders.cookieHeader: _cookie!})
        : await _client.get(uri);

    if (response.statusCode == 200) {
      return await compute(parseApiResponse, response.body);
    }
  } catch (e, s) {
    print('exception caught in doGet(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
    return null;
  }
}

Future<ApiResponse?> doPost(
    String path, Map<String, dynamic> queryParams, Object? body) async {
  final uri = Uri.https(domainName, path, queryParams);
  try {
    final response = _cookie != null
        ? await _client.post(uri,
            headers: {HttpHeaders.cookieHeader: _cookie!}, body: body)
        : await _client.post(uri,
            // headers: {
            //   HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            // },
            body: body);
    if (response.statusCode == 200) {
      if (response.headers[HttpHeaders.setCookieHeader] != null) {
        _cookie = response.headers[HttpHeaders.setCookieHeader];
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
