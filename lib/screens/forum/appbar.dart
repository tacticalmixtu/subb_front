import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subb_front/models/album.dart';
import 'package:subb_front/screens/me/signin.dart';

class ForumAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _ForumAppbarState createState() => _ForumAppbarState();

  @override
  // Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0))
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ForumAppbarState extends State<ForumAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('SUBB'),
      actions: <Widget>[
        // show sign up/sign in on web
        // kIsWeb
        //     ? Row(
        //         children: [
        //           InkWell(
        //             child: Container(
        //               padding: EdgeInsets.all(12.0),
        //               child: OutlinedButton(
        //                 onPressed: () {
        //                   Navigator.pushNamed(context, '/signin');
        //                 },
        //                 child: Text("Sign In"),
        //               ),
        //             ),
        //           ),
        //           InkWell(
        //             child: Container(
        //               // color: Theme.of(context).accentColor,
        //               padding: EdgeInsets.all(12.0),
        //               child: OutlinedButton(
        //                 onPressed: () {
        //                   // Respond to button press
        //                   Navigator.pushNamed(context, '/signup');
        //                 },
        //                 child: Text("Sign Up"),
        //               ),
        //             ),
        //           ),
        //         ],
        //       )
        //     : null,
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
  final List<Album> albums;

  ForumList({Key? key, required this.albums}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${albums[index].title}');
        return ListTile(
          title: Text('Forum placeholder'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
