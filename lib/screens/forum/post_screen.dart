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
import 'package:subb_front/screens/forum/compose_comment_screen.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:subb_front/utils/tool.dart';

class PostScreen extends StatelessWidget {
  static const routeName = '/post';

  final Post post;

  PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Comments (${post.comments})"),
      ),
      body: FutureBuilder<ApiResponse>(
        future: getPostPage(postId: post.postId.toString(), page: '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('PostScreen FutureBuilder ${snapshot.error}');
          return snapshot.hasData
              ? CommentsList(
                  comments:
                      parseComments(snapshot.data!.data! as List<dynamic>))
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComposeCommentScreen(post)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  final FocusNode _fn = FocusNode();

  CommentsList({Key? key, required this.comments}) : super(key: key);

  QuillController _getController(Comment comment) {
    return QuillController(
        document: Document.fromJson(jsonDecode(comment.content)),
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

  Widget _buildCard(Comment comment) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: comment.author.toString());
    return FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container(
                margin: EdgeInsets.all(4),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person_pin),
                        title: Text('User ID - ${comment.author}'),
                        trailing: Column(children: [
                          Text(
                              '${epochtoCustomTimeDisplay(comment.timestamp)}'),
                        ]),
                      ),
                      _buildContent(_getController(comment)),
                    ],
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(
                  margin: EdgeInsets.all(4),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person_pin),
                          title: Text('User ID - ${comment.author}'),
                          trailing: Column(children: [
                            Text(
                                '${epochtoCustomTimeDisplay(comment.timestamp)}'),
                          ]),
                        ),
                        _buildContent(_getController(comment)),
                      ],
                    ),
                  ),
                );
              } else {
                final ContactData authorData =
                    ContactData.fromJson(snapshot.data!.data! as dynamic);
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.network(authorData.avatarLink),
                        title: Text(authorData.nickname),
                        trailing: Column(children: [
                          Text(
                              '${epochtoCustomTimeDisplay(comment.timestamp)}'),
                        ]),
                      ),
                      _buildContent(_getController(comment)),
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommentScreen(comment: comments[index])));
          },
          child: _buildCard(comments[index]),
        );
      },
    );
  }
}
