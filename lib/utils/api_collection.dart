import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/utils/network.dart';

const _apiPathSignUp = "small_talk_api/sign_up";
const _apiPathSignIn = "small_talk_api/sign_in";
const _apiPathSignOut = "small_talk_api/sign_out";
const _apiPathRecoverPassword = "small_talk_api/recover_password";
const _apiPathRequestPasscode = "small_talk_api/request_passcode";
const _apiPathModifyInfo = "small_talk_api/modify_info";
const _apiPathNewThread = "small_talk_api/new_thread";
const _apiPathNewPost = "small_talk_api/new_post";
const _apiPathNewComment = "small_talk_api/new_comment";
const _apiPathDeleteThread = "small_talk_api/delete_thread";
const _apiPathDeletePost = "small_talk_api/delete_post";
const _apiPathDeleteComment = "small_talk_api/delete_comment";
const _apiPathVoteThread = "small_talk_api/vote_thread";
const _apiPathVotePost = "small_talk_api/vote_post";
const _apiPathVoteComment = "small_talk_api/vote_comment";
const _apiPathHasVotedThread = "small_talk_api/has_voted_thread";
const _apiPathHasVotedPost = "small_talk_api/has_voted_post";
const _apiPathHasVotedComment = "small_talk_api/has_voted_comment";
const _apiPathGetForum = "small_talk_api/get_forum";
const _apiPathGetThread = "small_talk_api/get_thread";
const _apiPathGetPost = "small_talk_api/get_post";
const _apiPathGetComment = "small_talk_api/get_comment";
const _apiPathGetHomepage = "small_talk_api/get_homepage";
const _apiPathGetForumList = "small_talk_api/get_forum_list";
const _apiPathGetForumPage = "small_talk_api/get_forum_page";
const _apiPathGetThreadPage = "small_talk_api/get_thread_page";
const _apiPathGetPostPage = "small_talk_api/get_post_page";
const _apiPathGetCommentPage = "small_talk_api/get_comment_page";
const _apiPathGetThreadHistory = "small_talk_api/get_thread_history";
const _apiPathGetPostHistory = "small_talk_api/get_post_history";
const _apiPathGetCommentHistory = "small_talk_api/get_comment_history";
const _apiPathGetBrowsingHistory = "small_talk_api/get_browsing_history";
const _apiPathLoadSelf = "small_talk_api/load_self";
const _apiPathLoadUser = "small_talk_api/load_user";
const _apiPathPushPrivateMessage = "small_talk_api/push_private_message";
const _apiPathFetchPrivateMessage = "small_talk_api/fetch_private_message";
const _apiPathReadPrivateMessage = "small_talk_api/read_private_message";
const _apiPathGetNotification = "small_talk_api/get_notification";
const _apiPathReadNotification = "small_talk_api/read_notification";

Future<ApiResponse> signUp({
  required String email,
  required String password,
  required String passcode,
}) async {
  return await doPost(
      _apiPathSignUp,
      {
        'email': email,
        'password': password,
        'passcode': passcode,
      },
      null);
}

Future<ApiResponse> recoverPassword({
  required String email,
  required String password,
  required String passcode,
}) async {
  return await doPost(
      _apiPathRecoverPassword,
      {
        'email': email,
        'password': password,
        'passcode': passcode,
      },
      null);
}

Future<ApiResponse> signIn({
  required String email,
  required String password,
}) async {
  return await doPost(
      _apiPathSignIn,
      {
        'email': email,
        'password': password,
      },
      null);
}

Future<ApiResponse> signOut() async {
  return await doPost(_apiPathSignOut, null, null);
}

Future<ApiResponse> requestPasscode({
  required String email,
}) async {
  return await doPost(
      _apiPathRequestPasscode,
      {
        'email': email,
      },
      null);
}

Future<ApiResponse> modifyInfo({
  String? nickname,
  String? password,
  String? gender,
  String? avatarLink,
  String? personalInfo,
}) async {
  return await doPost(
      _apiPathModifyInfo,
      {
        'nickname': nickname,
        'password': password,
        'gender': gender,
        'avatar_link': avatarLink,
        'personal_info': personalInfo,
      },
      null);
}

Future<ApiResponse> newThread({
  required String forumId,
  required String title,
  required String content,
}) async {
  return await doPost(
      _apiPathNewThread,
      {
        'forum_id': forumId,
        'title': title,
      },
      content);
}

Future<ApiResponse> newPost({
  required String threadId,
  String? quoteId,
  required String content,
}) async {
  return await doPost(
      _apiPathNewPost,
      {
        'thread_id': threadId,
        'quote_id': quoteId,
      },
      content);
}

Future<ApiResponse> newComment({
  required String postId,
  String? quoteId,
  required String content,
}) async {
  return await doPost(
      _apiPathNewComment,
      {
        'post_id': postId,
        'quote_id': quoteId,
      },
      content);
}

Future<ApiResponse> deleteThread({
  required String threadId,
}) async {
  return await doPost(
      _apiPathDeleteThread,
      {
        'thread_id': threadId,
      },
      null);
}

Future<ApiResponse> deletePost({
  required String postId,
}) async {
  return await doPost(
      _apiPathDeletePost,
      {
        'post_id': postId,
      },
      null);
}

Future<ApiResponse> deleteComment({
  required String commentId,
}) async {
  return await doPost(
      _apiPathDeleteComment,
      {
        'comment_id': commentId,
      },
      null);
}

Future<ApiResponse> voteThread({
  required String threadId,
}) async {
  return await doPost(
      _apiPathVoteThread,
      {
        'thread_id': threadId,
      },
      null);
}

Future<ApiResponse> votePost({
  required String postId,
}) async {
  return await doPost(
      _apiPathVotePost,
      {
        'post_id': postId,
      },
      null);
}

Future<ApiResponse> voteComment({
  required String commentId,
}) async {
  return await doPost(
      _apiPathVoteComment,
      {
        'comment_id': commentId,
      },
      null);
}

Future<ApiResponse> hasVotedThread({
  required String threadId,
}) async {
  return await doGet(_apiPathHasVotedThread, {
    'thread_id': threadId,
  });
}

Future<ApiResponse> hasVotedPost({
  required String postId,
}) async {
  return await doGet(_apiPathHasVotedPost, {
    'post_id': postId,
  });
}

Future<ApiResponse> hasVotedComment({
  required String commentId,
}) async {
  return await doGet(_apiPathHasVotedComment, {
    'comment_id': commentId,
  });
}

Future<ApiResponse> getForum({
  required String forumId,
}) async {
  return await doGet(_apiPathGetForum, {
    'forum_id': forumId,
  });
}

Future<ApiResponse> getThread({
  required String threadId,
}) async {
  return await doGet(_apiPathGetThread, {
    'thread_id': threadId,
  });
}

Future<ApiResponse> getPost({
  required String postId,
}) async {
  return await doGet(_apiPathGetPost, {
    'post_id': postId,
  });
}

Future<ApiResponse> getComment({
  required String commentId,
}) async {
  return await doGet(_apiPathGetComment, {
    'comment_id': commentId,
  });
}

Future<ApiResponse> getHomepage() async {
  return await doGet(_apiPathGetHomepage, null);
}

Future<ApiResponse> getForumList() async {
  return await doGet(_apiPathGetForumList, null);
}

Future<ApiResponse> getForumPage({
  required String forumId,
  required String page,
}) async {
  return await doGet(_apiPathGetForumPage, {
    'forum_id': forumId,
    'page': page,
  });
}

Future<ApiResponse> getThreadPage({
  required String threadId,
  required String page,
}) async {
  return await doGet(_apiPathGetThreadPage, {
    'thread_id': threadId,
    'page': page,
  });
}

Future<ApiResponse> getPostPage({
  required String postId,
  required String page,
}) async {
  return await doGet(_apiPathGetPostPage, {
    'post_id': postId,
    'page': page,
  });
}

Future<ApiResponse> getCommentPage({
  required String commentId,
  required String page,
}) async {
  return await doGet(_apiPathGetCommentPage, {
    'comment_id': commentId,
    'page': page,
  });
}

Future<ApiResponse> getThreadHistory({
  required String page,
}) async {
  return await doGet(_apiPathGetThreadHistory, {
    'page': page,
  });
}

Future<ApiResponse> getPostHistory({
  required String page,
}) async {
  return await doGet(_apiPathGetPostHistory, {
    'page': page,
  });
}

Future<ApiResponse> getCommentHistory({
  required String page,
}) async {
  return await doGet(_apiPathGetCommentHistory, {
    'page': page,
  });
}

Future<ApiResponse> getBrowsingHistory({
  required String page,
}) async {
  return await doGet(_apiPathGetBrowsingHistory, {
    'page': page,
  });
}

Future<ApiResponse> loadSelf() async {
  return await doGet(_apiPathLoadSelf, null);
}

Future<ApiResponse> loadUser({
  required String userId,
}) async {
  return await doGet(_apiPathLoadUser, {
    'user_id': userId,
  });
}

Future<ApiResponse> pushPrivateMessage({
  required String userId,
}) async {
  return await doPost(
      _apiPathPushPrivateMessage,
      {
        'user_id': userId,
      },
      null);
}

Future<ApiResponse> fetchPrivateMessage() async {
  return await doGet(_apiPathFetchPrivateMessage, null);
}

Future<ApiResponse> readPrivateMessage({
  required String messageId,
}) async {
  return await doPost(
      _apiPathReadPrivateMessage,
      {
        'message_id': messageId,
      },
      null);
}

Future<ApiResponse> getNotification() async {
  return await doGet(_apiPathGetNotification, null);
}

Future<ApiResponse> readNotification({
  required String notificationId,
}) async {
  return await doPost(
      _apiPathReadNotification,
      {
        'notification_id': notificationId,
      },
      null);
}
