enum CommentStatus {
  comment_status_draft,
  comment_status_visible,
  comment_status_deleted,
}

enum EnumGender {
  gender_hidden,
  gender_male,
  gender_female,
  gender_others,
}

enum EnumMessageStatus {
  message_status_unread,
  message_status_read,
}

enum EnumMessageType {
  message_type_system,
  message_type_private,
}

enum EnumNotificationStatus {
  notification_status_unread,
  notification_status_read,
}

enum EnumNotificationType {
  notification_type_comment_quote,
  notification_type_root_author,
  notification_type_post_author,
  notification_type_post_quote,
  notification_type_thread_author,
}

enum EnumPostStatus {
  post_status_draft,
  post_status_visible,
  post_status_deleted,
}

enum EnumThreadStatus {
  thread_status_draft,
  thread_status_visible,
  thread_status_deleted,
}

enum EnumUserPrivilege {
  privilege_normal,
  privilege_admin,
  privilege_suspended,
}
