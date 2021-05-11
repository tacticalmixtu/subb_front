import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:subb_front/constants.dart';
import 'package:subb_front/models/api_response.dart';

Future<ApiResponse?> doGet(
    String path, Map<String, dynamic> queryParams) async {
  final uri = Uri.https(domainName, path, queryParams);
  // final uri = Uri.https(testDomainName, '/get', queryParams);
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return await compute(_parseResponseBody, response.body);
    }
  } catch (e) {
    print('exception caught in doGet(): $e');
    return null;
  }
}

Future<ApiResponse?> doPost(
    String path, Map<String, dynamic> queryParams, Object? body) async {
  final uri = Uri.https(domainName, path, queryParams);
  try {
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    if (response.statusCode == 200) {
      return await compute(_parseResponseBody, response.body);
    }
  } catch (e, s) {
    print('exception caught in doGet():');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
    return null;
  }
}

ApiResponse _parseResponseBody(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  final response = ApiResponse.fromJson(parsed);
  return response;
}
