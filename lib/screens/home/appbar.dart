import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subb_front/models/album.dart';
import 'package:subb_front/screens/me/signin.dart';

class MyAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _MyAppbarState createState() => _MyAppbarState();

  @override
  // Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0))
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // TODO: navigation menu?
      // leading: IconButton(
      //   Icons.menu,
      // ),
      title: Text('SUBB'),
      actions: <Widget>[
        kIsWeb
            ? Row(
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // Respond to button press
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text("Sign In"),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      // color: Theme.of(context).accentColor,
                      padding: EdgeInsets.all(12.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // Respond to button press
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text("Sign Up"),
                      ),
                    ),
                  ),
                ],
              )
            : IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, SigninScreen.routeName);
                }),
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            }),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        // ),
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
          title: Text('${albums[index].title}'),
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
