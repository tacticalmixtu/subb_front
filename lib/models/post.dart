import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

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

// A function that converts a response body into a List<Thread>.
List<Post> parsePosts(List<dynamic> data) {
  return data.map((e) => Post.fromJson(e)).toList();
}

const _apiPath = 'small_talk_api/get_thread_page';

Future<List<Post>> fetchPosts(String threadID, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPath, {'post_id': threadID, 'page': page});
    if (apiResponse != null) {
      return parsePosts(apiResponse.data! as List<dynamic>);
    } else {
      print("_fetchPosts() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchPosts(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
