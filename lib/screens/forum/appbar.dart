import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subb_front/models/models.dart';

class ForumAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _ForumAppbarState createState() => _ForumAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ForumAppbarState extends State<ForumAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('SUBB'),
      elevation: 4.0,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            }),
      ],
    );
  }
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) =>
      <Widget>[IconButton(icon: Icon(Icons.clear), onPressed: () {})];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      });

  @override
  Widget buildResults(BuildContext context) => Container(
        child: Center(
          child: Text("Search result page"),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggesstionList = ["hi"];
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggesstionList[index]),
        );
      },
      itemCount: suggesstionList.length,
    );
  }
}

class ForumList extends StatelessWidget {
  final List<ForumData> forums;

  ForumList({Key? key, required this.forums}) : super(key: key);

  Widget _buildCard(ForumData forum) => ListTile(
        title: Text(forum.title),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: forums.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: _buildCard(forums[index]),
        );
      },
    );
  }
}
