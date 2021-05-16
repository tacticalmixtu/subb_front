import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/comment.dart';
import 'package:subb_front/screens/forum/composechildcomment.dart';
import 'package:subb_front/utils/api_collection.dart';

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
      body: FutureBuilder<ApiResponse>(
        future: getCommentPage(commentId: comment.commentId.toString(), page: '1'),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            print('CommentScreen FutureBuilder ${snapshot.error}');
          return snapshot.hasData
              ? ChildCommentsList(comments: parseComments(snapshot.data!.data! as List<dynamic>))
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
                  builder: (context) => ComposeChildCommentScreen(comment)));
        },
        child: Icon(Icons.add),
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
