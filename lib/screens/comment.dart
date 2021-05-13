import 'package:flutter/material.dart';
import 'package:subb_front/models/comment.dart';

class CommentScreen extends StatelessWidget {
  static const routeName = '/comment';

  final Comment comment;

  CommentScreen({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: FutureBuilder<List<Comment>>(
        future: fetchChildComments(comment.commentId.toString(), '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('CommentScreen FutureBuilder ${snapshot.error}');

          return snapshot.hasData
              ? ChildCommentsList(comments: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ChildCommentsList extends StatelessWidget {
  final List<Comment> comments;

  ChildCommentsList({Key? key, required this.comments}) : super(key: key);

  Widget _buildCard(Comment childComment) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(childComment.content),
                subtitle: Text('$childComment.author'),
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
        return _buildCard(comments[index]);
      },
    );
  }
}