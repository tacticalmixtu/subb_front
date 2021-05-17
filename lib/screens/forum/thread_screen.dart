import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/compose_post_screen.dart';
import 'package:subb_front/screens/forum/post_screen.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:subb_front/utils/tool.dart';

class ThreadScreen extends StatelessWidget {
  static const routeName = '/thread';

  final Thread thread;

  ThreadScreen({Key? key, required this.thread}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComposePostScreen(thread)));
        },
        child: Icon(Icons.edit),
      ),
      body: FutureBuilder<ApiResponse>(
        future: getThreadPage(threadId: thread.threadId.toString(), page: '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('ThreadScreen FutureBuilder ${snapshot.error}');
          return snapshot.hasData
              ? PostsList(
                  posts: parsePosts(snapshot.data!.data! as List<dynamic>))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final FocusNode _fn = FocusNode();

  PostsList({Key? key, required this.posts}) : super(key: key);

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: quillEditor,
    );
  }

  Widget _buildCard(Post post) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: post.author.toString());
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostScreen(post: posts[index])));
          },
          child: _buildCard(posts[index]),
        );
      },
    );
  }
}
