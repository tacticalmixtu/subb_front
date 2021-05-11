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
  Object? data;

  ApiResponse(this.code, this.message, this.data);

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

// A function that converts a response body into a List<Photo>.
// List<ApiResponse> parseMessages(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<ApiResponse>((json) => ApiResponse.fromJson(json)).toList();
// }

// Future<List<Album>> fetchAlbums(http.Client client) async {
//   final response = await client
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parseAlbums, response.body);
// }

// Future<Album> fetchAlbum() async {
//   final response =
//       await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
