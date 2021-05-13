import 'package:flutter/material.dart';
import 'package:subb_front/models/comment.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/screens/comment.dart';

class PostScreen extends StatelessWidget {
  static const routeName = '/post';

  final Post post;

  PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: FutureBuilder<List<Comment>>(
        future: fetchComments(post.postId.toString(), '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('PostScreen FutureBuilder ${snapshot.error}');

          return snapshot.hasData
              ? CommentsList(comments: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<Comment> comments;

  CommentsList({Key? key, required this.comments}) : super(key: key);

  Widget _buildCard(Comment comment) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(comment.content),
                subtitle: Text('$comment.author'),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${photos[index].title}');
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
