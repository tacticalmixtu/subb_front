// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) {
  return Thread(
    json['threadId'] as int,
    json['forumId'] as int,
    json['title'] as String,
    json['author'] as int,
    json['createTimestamp'] as int,
    json['activeTimestamp'] as int,
    json['status'] as String,
    json['posts'] as int,
    json['views'] as int,
    json['votes'] as int,
    json['heat'] as int,
  );
}

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'threadId': instance.threadId,
      'forumId': instance.forumId,
      'title': instance.title,
      'author': instance.author,
      'createTimestamp': instance.createTimestamp,
      'activeTimestamp': instance.activeTimestamp,
      'status': instance.status,
      'posts': instance.posts,
      'views': instance.views,
      'votes': instance.votes,
      'heat': instance.heat,
    };
