import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: 'post_id')
  int postId;
  @JsonKey(name: 'thread_id')
  int threadId;
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

  Post(this.postId, this.threadId, this.author, this.timestamp, this.quoteId,
      this.content, this.status, this.comments, this.votes);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

List<Post> parsePosts(List<dynamic> data) {
  return data.map((e) => Post.fromJson(e)).toList();
}
