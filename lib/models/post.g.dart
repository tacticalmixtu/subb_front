// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['post_id'] as int,
    json['thread_id'] as int,
    json['author'] as int,
    json['timestamp'] as int,
    json['quote_id'] as int,
    json['content'] as String,
    json['status'] as String,
    json['comments'] as int,
    json['votes'] as int,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'post_id': instance.postId,
      'thread_id': instance.threadId,
      'author': instance.author,
      'timestamp': instance.timestamp,
      'quote_id': instance.quoteId,
      'content': instance.content,
      'status': instance.status,
      'comments': instance.comments,
      'votes': instance.votes,
    };
