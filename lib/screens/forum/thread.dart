import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/composepost.dart';
import 'package:subb_front/screens/forum/post.dart';
import 'package:subb_front/utils/api_collection.dart';

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
              ? PostsList(posts: parsePosts(snapshot.data!.data! as List<dynamic>))
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
                  builder: (context) => ComposePostScreen(thread)));
        },
        child: Icon(Icons.add),
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

  Widget _buildCard(Post post) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.person_pin,
                ),
                title: Text('posted by: author ${post.author}'),
                subtitle: Text('parent thread: ${post.threadId}'),
              ),
              Image.network(r'https://picsum.photos/100'),
              _buildContent(_getController(post)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${photos[index].title}');
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