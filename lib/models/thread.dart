import 'package:json_annotation/json_annotation.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  @JsonKey(name: 'thread_id')
  int threadId;
  @JsonKey(name: 'forum_id')
  int forumId;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'author')
  int author;
  @JsonKey(name: 'create_timestamp')
  int createTimestamp;
  @JsonKey(name: 'active_timestamp')
  int activeTimestamp;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'posts')
  int posts;
  @JsonKey(name: 'views')
  int views;
  @JsonKey(name: 'votes')
  int votes;
  @JsonKey(name: 'heat')
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

List<Thread> parseThreads(List<dynamic> data) {
  return data.map((e) => Thread.fromJson(e)).toList();
}
