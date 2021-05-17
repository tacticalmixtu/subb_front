import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/comment.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/screens/forum/comment_screen.dart';
import 'package:subb_front/screens/forum/post_screen.dart';
import 'package:subb_front/screens/notification/message_screen.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:subb_front/utils/tool.dart';

class NotificationScreen extends StatelessWidget {
  Tab _buildTabItem(IconData icond, String label) {
    return Tab(
        child: Row(
      children: [
        Spacer(
          flex: 4,
        ),
        Icon(icond),
        Spacer(
          flex: 1,
        ),
        Text(label),
        Spacer(
          flex: 4,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            bottom: TabBar(
              tabs: [
                _buildTabItem(Icons.campaign, "Updates"),
                _buildTabItem(Icons.mail, "Messages"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UpdateScreen(),
              MessageScreen(),
            ],
          ),
        ));
  }
}

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late Future<ApiResponse> _futureResponse;

  @override
  void initState() {
    super.initState();
    _futureResponse = getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (snapshot.data!.code == 200) {
                  return RefreshIndicator(
                      child: UpdateList(
                          notifications: parseNotificationList(
                              snapshot.data!.data! as List<dynamic>)),
                      onRefresh: () {
                        setState(() {
                          _futureResponse = getNotification();
                        });
                        return _futureResponse;
                      });
                } else {
                  return Center(
                      child:
                          Text('Sign in to view notifications and messages.'));
                }
              }
          }
        });
  }
}

class UpdateList extends StatelessWidget {
  final List<NotificationData> notifications;
  UpdateList({Key? key, required this.notifications});

  QuillController _getController(String content) {
    return QuillController(
        document: Document.fromJson(jsonDecode(content)),
        selection: const TextSelection.collapsed(offset: 0));
  }

  Widget _buildContent(QuillController? controller) {
    final FocusNode _fn = FocusNode();
    var quillEditor = QuillEditor(
      controller: controller!,
      focusNode: _fn,
      scrollController: ScrollController(),
      scrollable: true,
      padding: EdgeInsets.zero,
      autoFocus: true,
      showCursor: false,
      readOnly: true,
      expands: false,
    );
    _fn.unfocus();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: quillEditor,
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Post post) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: post.author.toString());
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostScreen(post: post)));
        },
        child: FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                final ContactData authorData =
                    ContactData.fromJson(snapshot.data!.data! as dynamic);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Chip(
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(authorData.avatarLink),
                                ),
                                label: Text(authorData.nickname)),
                          ),
                          Flexible(
                              child: Text(
                            '${epochToDateTime(post.timestamp)}',
                            style: TextStyle(fontSize: 16),
                          )),
                        ],
                      ),
                      _buildContent(_getController(post.content)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Chip(
                              avatar: Icon(Icons.comment_outlined),
                              label: Text("${post.comments}"),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ActionChip(
                              avatar: Icon(Icons.thumb_up_outlined),
                              label: Text("${post.votes}"),
                              onPressed: () async {
                                await votePost(postId: post.postId.toString());
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1),
                    ],
                  ),
                );
              }
          }
        }));
  }

  Widget _buildCommentCard(BuildContext context, Comment comment) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: comment.author.toString());
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentScreen(comment: comment)));
        },
        child: FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                final ContactData authorData =
                    ContactData.fromJson(snapshot.data!.data! as dynamic);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Chip(
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(authorData.avatarLink),
                                ),
                                label: Text(authorData.nickname)),
                          ),
                          Flexible(
                              child: Text(
                            '${epochToDateTime(comment.timestamp)}',
                            style: TextStyle(fontSize: 16),
                          )),
                        ],
                      ),
                      _buildContent(_getController(comment.content)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Chip(
                              avatar: Icon(Icons.comment_outlined),
                              label: Text("${comment.comments}"),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ActionChip(
                              avatar: Icon(Icons.thumb_up_outlined),
                              label: Text("${comment.votes}"),
                              onPressed: () async {
                                await voteComment(commentId: comment.commentId.toString());
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1),
                    ],
                  ),
                );
              }
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          switch (notifications[index].notificationType) {
            case 'notification_type_comment_quote':
              final Future<ApiResponse> _futureResponse = getComment(
                  commentId:
                      notifications[index].notificationReplyId.toString());
              return FutureBuilder<ApiResponse>(
                  future: _futureResponse,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error_outline));
                        } else {
                          return _buildCommentCard(context,
                              Comment.fromJson(snapshot.data!.data as dynamic));
                        }
                    }
                  });
            case 'notification_type_root_author':
              final Future<ApiResponse> _futureResponse = getComment(
                  commentId:
                      notifications[index].notificationReplyId.toString());
              return FutureBuilder<ApiResponse>(
                  future: _futureResponse,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error_outline));
                        } else {
                          return _buildCommentCard(context,
                              Comment.fromJson(snapshot.data!.data as dynamic));
                        }
                    }
                  });
            case 'notification_type_post_author':
              final Future<ApiResponse> _futureResponse = getComment(
                  commentId:
                      notifications[index].notificationReplyId.toString());
              return FutureBuilder<ApiResponse>(
                  future: _futureResponse,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error_outline));
                        } else {
                          return _buildCommentCard(context,
                              Comment.fromJson(snapshot.data!.data as dynamic));
                        }
                    }
                  });
            case 'notification_type_post_quote':
              final Future<ApiResponse> _futureResponse = getPost(
                  postId: notifications[index].notificationReplyId.toString());
              return FutureBuilder<ApiResponse>(
                  future: _futureResponse,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error_outline));
                        } else {
                          return _buildPostCard(context,
                              Post.fromJson(snapshot.data!.data as dynamic));
                        }
                    }
                  });
            case 'notification_type_thread_author':
              final Future<ApiResponse> _futureResponse = getPost(
                  postId: notifications[index].notificationReplyId.toString());
              return FutureBuilder<ApiResponse>(
                  future: _futureResponse,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Icon(Icons.error_outline));
                        } else {
                          return _buildPostCard(context,
                              Post.fromJson(snapshot.data!.data as dynamic));
                        }
                    }
                  });
            default:
              return Center(child: Icon(Icons.error_outline));
          }
        });
  }
}
