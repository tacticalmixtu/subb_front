import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

// A function that converts a response body into a List<Photo>.
List<Album> parseAlbums(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

Future<List<Album>> fetchAlbums(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseAlbums, response.body);
}

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
