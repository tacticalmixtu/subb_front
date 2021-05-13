import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  @JsonKey(name: 'thread_id')
  int threadId;
  @JsonKey(name: 'forum_id')
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
List<Thread> parseThreads(Object data) {
  print(data);
  // return jsonDecode(data).cast<List<Thread>>();
  return data as List<Thread>;
  // print('8888888888*****************');
  // return parsed.map<Thread>((json) => Thread.fromJson(json)).toList();
}

Future<List<Thread>> fetchThreads(String forumID, String page) async {
  const _apiPath = 'small_talk_api/get_forum_page';
  // final apiResponse =
  //     await doGet(_apiPath, {'forum_id': forumID, 'page': page});
  // return compute(parseThreads, apiResponse!.data!);
  try {
    final apiResponse =
        await doGet(_apiPath, {'forum_id': forumID, 'page': page});

    if (apiResponse != null) {
      // print('code: ${apiResponse.code}');
      // print('message: ${apiResponse.message}');
      // print('data: ${apiResponse.data}');
      // return compute(parseThreads, apiResponse.data! as String);
      return parseThreads(apiResponse.data!);
    } else {
      print("_fetchThreads() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchThreads(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
