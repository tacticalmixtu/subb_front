import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  int threadId;
  int forumId;
  String title;
  int author;
  int createTimestamp;
  int activeTimestamp;
  String status;
  int posts;
  int views;
  int votes;
  int heat;

  Thread(
      this.threadId,
      this.forumId,
      this.title,
      this.author,
      this.createTimestamp,
      this.activeTimestamp,
      this.status,
      this.posts,
      this.views,
      this.votes,
      this.heat);

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadToJson(this);
}

// A function that converts a response body into a List<Thread>.
List<Thread> parseThreads(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Thread>((json) => Thread.fromJson(json)).toList();
}

const _apiPath = 'small_talk_api/get_thread_page';

Future<List<Thread>> fetchThreads(String forumID, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPath, {'forum_id': forumID, 'page': page});

    if (apiResponse != null) {
      // print('code: ${apiResponse.code}');
      // print('message: ${apiResponse.message}');
      // print('data: ${apiResponse.data}');
      return compute(parseThreads, apiResponse.data!);
    } else {
      print("_sendNewPost() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in doGet(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
