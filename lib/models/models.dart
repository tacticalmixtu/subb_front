import 'package:json_annotation/json_annotation.dart';

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

  Map<String, dynamic> toJson() => _$ContactDataToJson(this);
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

  Map<String, dynamic> toJson() => _$ForumDataToJson(this);
}

List<ForumData> parseForumList(List<dynamic> data) {
  return data.map((e) => ForumData.fromJson(e)).toList();
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

  Map<String, dynamic> toJson() => _$HistoryRecordToJson(this);
}

List<HistoryRecord> parseHistoryRecordList(List<dynamic> data) {
  return data.map((e) => HistoryRecord.fromJson(e)).toList();
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

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

List<Notification> parseNotificationList(List<dynamic> data) {
  return data.map((e) => Notification.fromJson(e)).toList();
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

  Map<String, dynamic> toJson() => _$PrivateMessageToJson(this);
}

List<PrivateMessage> parsePrivateMessageList(List<dynamic> data) {
  return data.map((e) => PrivateMessage.fromJson(e)).toList();
}
