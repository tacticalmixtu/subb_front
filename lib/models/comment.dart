import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

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

// A function that converts a response body into a List<Thread>.
List<Comment> parseComments(List<dynamic> data) {
  return data.map((e) => Comment.fromJson(e)).toList();
}

const _apiPath = 'small_talk_api/get_post_page';
const _apiPathCommentsUnderRoot = "small_talk_api/get_comment_page";

Future<List<Comment>> fetchComments(String postId, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPath, {'post_id': postId, 'page': page});
    if (apiResponse != null) {
      return parseComments(apiResponse.data! as List<dynamic>);
    } else {
      print("_fetchComments() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchComments(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}

Future<List<Comment>> fetchCommentsUnderRoot(String commentId, String page) async {
  try {
    final apiResponse =
        await doGet(_apiPathCommentsUnderRoot, {'comment_id': commentId, 'page': page});
    if (apiResponse != null) {
      return parseComments(apiResponse.data! as List<dynamic>);
    } else {
      print("_fetchCommentsUnderRoot() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchCommentsUnderRoot(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
