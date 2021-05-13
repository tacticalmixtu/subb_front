// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) {
  return Thread(
    json['thread_id'] as int,
    json['forum_id'] as int,
    json['title'] as String,
    json['author'] as int,
    json['create_timestamp'] as int,
    json['active_timestamp'] as int,
    json['status'] as String,
    json['posts'] as int,
    json['views'] as int,
    json['votes'] as int,
    json['heat'] as int,
  );
}

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'thread_id': instance.threadId,
      'forum_id': instance.forumId,
      'title': instance.title,
      'author': instance.author,
      'create_timestamp': instance.createTimestamp,
      'active_timestamp': instance.activeTimestamp,
      'status': instance.status,
      'posts': instance.posts,
      'views': instance.views,
      'votes': instance.votes,
      'heat': instance.heat,
    };
