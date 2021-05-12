// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['postId'] as int,
    json['threadId'] as int,
    json['author'] as int,
    json['timestamp'] as int,
    json['quoteId'] as int,
    json['content'] as String,
    json['status'] as String,
    json['comments'] as int,
    json['votes'] as int,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'postId': instance.postId,
      'threadId': instance.threadId,
      'author': instance.author,
      'timestamp': instance.timestamp,
      'quoteId': instance.quoteId,
      'content': instance.content,
      'status': instance.status,
      'comments': instance.comments,
      'votes': instance.votes,
    };
