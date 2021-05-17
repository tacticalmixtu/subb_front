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
    );
  }
}

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final FocusNode _fn = FocusNode();

  PostsList({Key? key, required this.posts}) : super(key: key);

  QuillController _getController(Post post) {
    return QuillController(
        document: Document.fromJson(jsonDecode(post.content)),
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
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_pin, size: 40),
                      title: Text('User ID - ${post.author}'),
                      trailing: Column(children: [
                        Text('${epochtoCustomTimeDisplay(post.timestamp)}'),
                      ]),
                    ),
                    _buildContent(_getController(post)),
                  ],
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.error_outline, size: 40),
                        title: Text('User ID - ${post.author}'),
                        trailing: Column(children: [
                          Text('${epochtoCustomTimeDisplay(post.timestamp)}'),
                        ]),
                      ),
                      _buildContent(_getController(post)),
                    ],
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
                          Text('${epochtoCustomTimeDisplay(post.timestamp)}'),
                        ]),
                      ),
                      _buildContent(_getController(post)),
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
