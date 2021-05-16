import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: 'comment_id')
  int commentId;
  @JsonKey(name: 'post_id')
  int postId;
  @JsonKey(name: 'root_id')
  int rootId;
  @JsonKey(name: 'author')
  int author;
  @JsonKey(name: 'timestamp')
  int timestamp;
  @JsonKey(name: 'quote_id')
  int quoteId;
  @JsonKey(name: 'content')
  String content;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'comments')
  int comments;
  @JsonKey(name: 'votes')
  int votes;

  Comment(
      this.commentId,
      this.postId,
      this.rootId,
      this.author,
      this.timestamp,
      this.quoteId,
      this.content,
      this.status,
      this.comments,
      this.votes);

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

List<Comment> parseComments(List<dynamic> data) {
  return data.map((e) => Comment.fromJson(e)).toList();
}
