// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    json['comment_id'] as int,
    json['post_id'] as int,
    json['root_id'] as int,
    json['author'] as int,
    json['timestamp'] as int,
    json['quote_id'] as int,
    json['content'] as String,
    json['status'] as String,
    json['comments'] as int,
    json['votes'] as int,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'comment_id': instance.commentId,
      'post_id': instance.postId,
      'root_id': instance.rootId,
      'author': instance.author,
      'timestamp': instance.timestamp,
      'quote_id': instance.quoteId,
      'content': instance.content,
      'status': instance.status,
      'comments': instance.comments,
      'votes': instance.votes,
    };
