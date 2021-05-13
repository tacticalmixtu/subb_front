import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final int code;
  final String message;
  // @JsonKey(defaultValue: null)
  Object? data;

  ApiResponse(this.code, this.message, this.data);

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

ApiResponse parseApiResponse(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  return ApiResponse.fromJson(parsed);
}
