import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/compose_thread_screen.dart';
import 'package:subb_front/screens/forum/thread_screen.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:subb_front/utils/tool.dart';

class ForumScreen extends StatefulWidget {
  static const routeName = '/forum';

  final ForumData forum;

  ForumScreen({Key? key, required this.forum}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState(forum);
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<ApiResponse> _futureResponse;

  final ForumData forum;

  _ForumScreenState(this.forum);

  @override
  void initState() {
    super.initState();
    _futureResponse =
        getForumPage(forumId: forum.forumId.toString(), page: '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(forum.title),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComposeThreadScreen(forum)));
        },
        child: Icon(Icons.add),
      ),
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
                    child: ThreadsPage(
                        threads: parseThreads(
                            snapshot.data!.data! as List<dynamic>)),
                    onRefresh: () {
                      setState(() {
                        _futureResponse =
                            getForumPage(forumId: forum.toString(), page: '1');
                      });
                      return _futureResponse;
                    },
                  );
                }
            }
          }),
    );
  }
}

class ThreadsPage extends StatelessWidget {
  final List<Thread> threads;
  ThreadsPage({Key? key, required this.threads});

  Widget _buildIconItem(IconData icon, String content) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blueGrey[400],
        ),
        Text(content),
      ],
    );
  }

  Widget _buildBottomContainer(Thread thread) {
    return Container(
      padding: EdgeInsets.only(left: 192),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildIconItem(Icons.whatshot, '${thread.heat}'),
        _buildIconItem(Icons.sms, '${thread.posts}'),
        _buildIconItem(Icons.thumb_up, '${thread.votes}'),
      ]),
    );
  }

  Widget _buildCard(Thread thread) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: thread.author.toString());
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
                      leading: new Icon(Icons.person_pin, size: 40.0),
                      title: Text('${thread.title}'),
                      subtitle: Text("User ID - ${thread.author}"),
                      trailing: Column(children: [
                        Text(
                            '${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
                      ]),
                    ),
                    _buildBottomContainer(thread),
                  ],
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: new Icon(Icons.error_outline, size: 40.0),
                        title: Text('${thread.title}'),
                        subtitle: Text("User ID - ${thread.author}"),
                        trailing: Column(children: [
                          Text(
                              '${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
                        ]),
                      ),
                      _buildBottomContainer(thread),
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
                        title: Text('${thread.title}'),
                        subtitle: Text(authorData.nickname),
                        trailing: Column(children: [
                          Text(
                              '${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
                        ]),
                      ),
                      _buildBottomContainer(thread),
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
      itemCount: threads.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThreadScreen(thread: threads[index])));
          },
          child: _buildCard(threads[index]),
        );
      },
    );
  }
}
