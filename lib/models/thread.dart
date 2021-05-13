import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

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

// A function that converts a response body into a List<Thread>.
List<Thread> parseThreads(List<dynamic> data) {
  return data.map((e) => Thread.fromJson(e)).toList();
}

const _apiPath = 'small_talk_api/get_forum_page';

Future<List<Thread>> fetchThreads(String forumID, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPath, {'forum_id': forumID, 'page': page});
    if (apiResponse != null) {
      return parseThreads(apiResponse.data! as List<dynamic>);
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
