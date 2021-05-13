import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int postId;
  int threadId;
  int author;
  int timestamp;
  int quoteId;
  String content;
  String status;
  int comments;
  int votes;

  Post(this.postId, this.threadId, this.author, this.timestamp, this.quoteId,
      this.content, this.status, this.comments, this.votes);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

// A function that converts a response body into a List<Thread>.
List<Post> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Post>((json) => Post.fromJson(json)).toList();
}

const _apiPath = 'small_talk_api/get_thread_page';

Future<List<Post>> fetchPosts(String threadID, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPath, {'post_id': threadID, 'page': page});

    if (apiResponse != null) {
      // print('code: ${apiResponse.code}');
      // print('message: ${apiResponse.message}');
      // print('data: ${apiResponse.data}');
      return compute(parsePosts, apiResponse.data! as String);
    } else {
      print("_fetchPosts() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchPosts(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
