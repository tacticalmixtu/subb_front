import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/screens/forum/compose_screen.dart';
import 'package:subb_front/screens/forum/forum_screen.dart';
import 'package:subb_front/utils/api_collection.dart';

class ForumListScreen extends StatefulWidget {
  static const routeName = '/forum_list';

  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  late Future<ApiResponse> _futureResponse;

  @override
  void initState() {
    super.initState();
    _futureResponse = getForumList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: FutureBuilder<ApiResponse>(
          future: _futureResponse,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return RefreshIndicator(
                    child: ForumsPage(
                        forums: parseForumList(
                            snapshot.data!.data! as List<dynamic>)),
                    onRefresh: () {
                      setState(() {
                        _futureResponse = getForumList();
                      });
                      return _futureResponse;
                    },
                  );
                  // });
                }
            }
          }),
    );
  }
}

class ForumsPage extends StatelessWidget {
  final List<ForumData> forums;
  ForumsPage({Key? key, required this.forums});

  Widget _buildCard(ForumData forum) => Container(
        child: Card(
          child: Column(
            children: [
              ListTile(
                // Todo: Forum Icon & Forum Description
                leading: new Icon(Icons.forum, size: 40.0),
                title: Text('${forum.title}'),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: forums.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForumScreen(forum: forums[index])));
          },
          child: _buildCard(forums[index]),
        );
      },
    );
  }
}
