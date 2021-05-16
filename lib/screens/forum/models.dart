import 'package:json_annotation/json_annotation.dart';
import 'package:subb_front/utils/network.dart';

part 'models.g.dart';

@JsonSerializable()
class ContactData {
  @JsonKey(name: 'contact_id')
  int contactId;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'privilege')
  String privilege;
  @JsonKey(name: 'gender')
  String gender;
  @JsonKey(name: 'avatar_link')
  String avatarLink;
  @JsonKey(name: 'personal_info')
  String personalInfo;
  @JsonKey(name: 'posts')
  int posts;
  @JsonKey(name: 'exp')
  int exp;
  @JsonKey(name: 'prestige')
  int prestige;

  ContactData(
      this.contactId,
      this.email,
      this.nickname,
      this.privilege,
      this.gender,
      this.avatarLink,
      this.personalInfo,
      this.posts,
      this.exp,
      this.prestige);  

  factory ContactData.fromJson(Map<String, dynamic> json) => _$ContactDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDataFromJson(this);
}

const _apiPathLoadSelf = 'small_talk_api/load_self';
const _apiPathLoadUser = 'small_talk_api/load_user';

Future<ContactData?> fetchSelf() async {
  try {
    final apiResponse =
        await doGet(_apiPathLoadSelf, null);
    if (apiResponse != null) {
      return ContactData.fromJson(apiResponse.data! as dynamic);
    } else {
      print("fetchSelf() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchSelf(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return null;
}

Future<ContactData?> fetchUser(int userId) async {
  try {
    final apiResponse =
        await doGet(_apiPathLoadUser, {'user_id': userId});
    if (apiResponse != null) {
      return ContactData.fromJson(apiResponse.data! as dynamic);
    } else {
      print("fetchUser() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchUser(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return null;
}

@JsonSerializable()
class ForumData {
  @JsonKey(name: 'forum_id')
  int forumId;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'threads')
  int threads;
  @JsonKey(name: 'heat')
  int heat;

  ForumData(
      this.forumId,
      this.title,
      this.threads,
      this.heat);  

  factory ForumData.fromJson(Map<String, dynamic> json) => _$ForumDataFromJson(json);

  Map<String, dynamic> toJson() => _$ForumDataFromJson(this);
}

List<ForumData> parseForumList(List<dynamic> data) {
  return data.map((e) => ForumData.fromJson(e)).toList();
}

const _apiPathLoadForumList = 'small_talk_api/load_forum_list';

Future<List<ForumData>> fetchForumList() async {
  try {
    final apiResponse =
        await doGet(_apiPathLoadForumList, null);
    if (apiResponse != null) {
      return parseForumList(apiResponse.data! as List<dynamic>);
    } else {
      print("fetchForumList() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchForumList(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}

@JsonSerializable()
class HistoryRecord {
  @JsonKey(name: 'history_record_id')
  int historyRecordId;
  @JsonKey(name: 'history_user_id')
  int historyUserId;
  @JsonKey(name: 'history_thread_id')
  int historyThreadId;
  @JsonKey(name: 'history_timestamp')
  int historyTimestamp;

  HistoryRecord(
      this.historyRecordId,
      this.historyUserId,
      this.historyThreadId,
      this.historyTimestamp);

  factory HistoryRecord.fromJson(Map<String, dynamic> json) => _$HistoryRecordFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryRecordFromJson(this);
}

List<HistoryRecord> parseHistoryRecordList(List<dynamic> data) {
  return data.map((e) => HistoryRecord.fromJson(e)).toList();
}

const _apiPathGetBrowsingHistory = 'small_talk_api/get_browsing_history';

Future<List<HistoryRecord>> fetchBrowsingHistory() async {
  try {
    final apiResponse =
        await doGet(_apiPathGetBrowsingHistory, null);
    if (apiResponse != null) {
      return parseHistoryRecordList(apiResponse.data! as List<dynamic>);
    } else {
      print("fetchBrowsingHistory() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchBrowsingHistory(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}

@JsonSerializable()
class Notification {
  @JsonKey(name: 'notification_id')
  int notificationId;
  @JsonKey(name: 'notification_user_id')
  int notificationUserId;
  @JsonKey(name: 'notification_reply_id')
  int notificationReplyId;
  @JsonKey(name: 'notification_type')
  String notificationType;
  @JsonKey(name: 'notification_status')
  String notificationStatus;

  Notification(
      this.notificationId,
      this.notificationUserId,
      this.notificationReplyId,
      this.notificationType,
      this.notificationStatus);  

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationFromJson(this);
}

List<Notification> parseNotificationList(List<dynamic> data) {
  return data.map((e) => Notification.fromJson(e)).toList();
}

const _apiPathGetNotification = 'small_talk_api/get_notification';

Future<List<Notification>> fetchNotificationList() async {
  try {
    final apiResponse =
        await doGet(_apiPathGetNotification, null);
    if (apiResponse != null) {
      return parseNotificationList(apiResponse.data! as List<dynamic>);
    } else {
      print("fetchNotificationList() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchNotificationList(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}

@JsonSerializable()
class PrivateMessage {
  @JsonKey(name: 'message_id')
  int messageId;
  @JsonKey(name: 'message_sender')
  int messageSender;
  @JsonKey(name: 'message_receiver')
  int messageReceiver;
  @JsonKey(name: 'message_type')
  String messageType;
  @JsonKey(name: 'message_status')
  String messageStatus;
  @JsonKey(name: 'message_content')
  String messageContent;
  @JsonKey(name: 'message_timestamp')
  int messageTimestamp;

  PrivateMessage(
      this.messageId,
      this.messageSender,
      this.messageReceiver,
      this.messageType,
      this.messageStatus,
      this.messageContent,
      this.messageTimestamp);  

  factory PrivateMessage.fromJson(Map<String, dynamic> json) => _$PrivateMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateMessageFromJson(this);
}

List<PrivateMessage> parsePrivateMessageList(List<dynamic> data) {
  return data.map((e) => PrivateMessage.fromJson(e)).toList();
}

const _apiPathFetchPrivateMessage = 'small_talk_api/fetch_private_message';

Future<List<PrivateMessage>> fetchPrivateMessage() async {
  try {
    final apiResponse =
        await doGet(_apiPathFetchPrivateMessage, null);
    if (apiResponse != null) {
      return parsePrivateMessageList(apiResponse.data! as List<dynamic>);
    } else {
      print("fetchPrivateMessage() error, null apiResponse");
    }
  } catch (e, s) {
    print('exception caught in fetchPrivateMessage(): $e');
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  return [];
}
