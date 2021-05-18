import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/comment.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/screens/forum/compose_child_comment_screen.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:subb_front/utils/tool.dart';

class CommentScreen extends StatelessWidget {
  static const routeName = '/comment';

  final Comment comment;

  CommentScreen({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Discussion (${comment.comments})"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComposeChildCommentScreen(comment)));
        },
        child: Icon(Icons.edit),
      ),
      body: FutureBuilder<ApiResponse>(
        future:
            getCommentPage(commentId: comment.commentId.toString(), page: '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('CommentScreen FutureBuilder ${snapshot.error}');
          return snapshot.hasData
              ? ChildCommentsList(
                  comments:
                      parseComments(snapshot.data!.data! as List<dynamic>))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChildCommentsList extends StatelessWidget {
  final List<Comment> comments;
  final FocusNode _fn = FocusNode();

  ChildCommentsList({Key? key, required this.comments}) : super(key: key);

  QuillController _getController(String content) {
    return QuillController(
        document: Document.fromJson(jsonDecode(content)),
        selection: const TextSelection.collapsed(offset: 0));
  }

  Widget _buildContent(QuillController? controller) {
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

  Widget _buildCard(Comment childComment) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: childComment.author.toString());
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
                            '${epochToDateTime(childComment.timestamp)}',
                            style: TextStyle(fontSize: 16),
                          )),
                        ],
                      ),
                      _buildContent(_getController(childComment.content)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ActionChip(
                              avatar: Icon(Icons.thumb_up_outlined),
                              label: Text("${childComment.votes}"),
                              onPressed: () async {
                                await voteComment(
                                    commentId:
                                        childComment.commentId.toString());
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _buildCard(comments[index]);
      },
    );
  }
}
