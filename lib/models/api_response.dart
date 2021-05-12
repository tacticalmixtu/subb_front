import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  // final int code;
  // final String message;
  // final Object? data;

  // ApiResponse({required this.code, required this.message, this.data});

  // factory ApiResponse.fromJson(Map<String, dynamic> json) {
  //   return ApiResponse(
  //     code: json['code'],
  //     message: json['message'],
  //     data: json['data'],
  //   );
  // }

  final int code;
  final String message;
  @JsonKey(defaultValue: null)
  String? data;

  ApiResponse(this.code, this.message, this.data);

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

ApiResponse parseApiResponse(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  final response = ApiResponse.fromJson(parsed);
  return response;
}
