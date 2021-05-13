import 'package:flutter/material.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/post.dart';

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
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(thread.threadId.toString(), '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('ThreadScreen FutureBuilder ${snapshot.error}');

          return snapshot.hasData
              ? PostsList(posts: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final List<Post> posts;

  PostsList({Key? key, required this.posts}) : super(key: key);

  Widget _buildCard(Post post) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(post.content),
                subtitle: Text('$post.author'),
              ),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PostScreen(post: posts[index])));
          },
          child: _buildCard(posts[index]),
        );
      },
    );
  }
}
