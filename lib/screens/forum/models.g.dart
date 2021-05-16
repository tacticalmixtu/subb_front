// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactData _$ContactDataFromJson(Map<String, dynamic> json) {
  return ContactData(
    json['contact_id'] as int,
    json['email'] as String,
    json['nickname'] as String,
    json['privilege'] as String,
    json['gender'] as String,
    json['avatar_link'] as String,
    json['personal_info'] as String,
    json['posts'] as int,
    json['exp'] as int,
    json['prestige'] as int,
  );
}

Map<String, dynamic> _$ContactDataToJson(ContactData instance) =>
    <String, dynamic>{
      'contact_id': instance.contactId,
      'email': instance.email,
      'nickname': instance.nickname,
      'privilege': instance.privilege,
      'gender': instance.gender,
      'avatar_link': instance.avatarLink,
      'personal_info': instance.personalInfo,
      'posts': instance.posts,
      'exp': instance.exp,
      'prestige': instance.prestige,
    };

ForumData _$ForumDataFromJson(Map<String, dynamic> json) {
  return ForumData(
    json['forum_id'] as int,
    json['title'] as String,
    json['threads'] as int,
    json['heat'] as int,
  );
}

Map<String, dynamic> _$ForumDataToJson(ForumData instance) => <String, dynamic>{
      'forum_id': instance.forumId,
      'title': instance.title,
      'threads': instance.threads,
      'heat': instance.heat,
    };

HistoryRecord _$HistoryRecordFromJson(Map<String, dynamic> json) {
  return HistoryRecord(
    json['history_record_id'] as int,
    json['history_user_id'] as int,
    json['history_thread_id'] as int,
    json['history_timestamp'] as int,
  );
}

Map<String, dynamic> _$HistoryRecordToJson(HistoryRecord instance) =>
    <String, dynamic>{
      'history_record_id': instance.historyRecordId,
      'history_user_id': instance.historyUserId,
      'history_thread_id': instance.historyThreadId,
      'history_timestamp': instance.historyTimestamp,
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    json['notification_id'] as int,
    json['notification_user_id'] as int,
    json['notification_reply_id'] as int,
    json['notification_type'] as String,
    json['notification_status'] as String,
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'notification_id': instance.notificationId,
      'notification_user_id': instance.notificationUserId,
      'notification_reply_id': instance.notificationReplyId,
      'notification_type': instance.notificationType,
      'notification_status': instance.notificationStatus,
    };

PrivateMessage _$PrivateMessageFromJson(Map<String, dynamic> json) {
  return PrivateMessage(
    json['message_id'] as int,
    json['message_sender'] as int,
    json['message_receiver'] as int,
    json['message_type'] as String,
    json['message_status'] as String,
    json['message_content'] as String,
    json['message_timestamp'] as int,
  );
}

Map<String, dynamic> _$PrivateMessageToJson(PrivateMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'message_sender': instance.messageSender,
      'message_receiver': instance.messageReceiver,
      'message_type': instance.messageType,
      'message_status': instance.messageStatus,
      'message_content': instance.messageContent,
      'message_timestamp': instance.messageTimestamp,
    };
