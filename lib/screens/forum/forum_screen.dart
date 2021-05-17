import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/compose_post_screen.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComposeThreadScreen(forum)));
        },
        child: Icon(Icons.edit),
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
                            getForumPage(forumId: forum.forumId.toString(), page: '1');
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

  Widget _buildUI({
    required BuildContext context,
    required Thread thread,
    required String authorNickName,
    required String avatarLink,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(avatarLink),
                    ),
                    label: Text(authorNickName)),
              ),
              Flexible(
                  child: Text(
                '${epochToCustomTimeDisplay(thread.activeTimestamp)}',
                style: TextStyle(fontSize: 16),
              )),
            ],
          ),
          Text(
            '${thread.title}',
            style: TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Chip(
                  avatar: Icon(Icons.comment_outlined),
                  label: Text("${thread.posts}"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ActionChip(
                  avatar: Icon(Icons.thumb_up_outlined),
                  label: Text("${thread.votes}"),
                  onPressed: () async {
                    await voteThread(threadId: thread.threadId.toString());
                  },
                ),
              ),
            ],
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _buildThreadSummary(Thread thread, int index) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: thread.author.toString());
    return FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Icon(Icons.error_outline));
              } else {
                final contactData =
                    ContactData.fromJson(snapshot.data!.data! as dynamic);
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ThreadScreen(thread: thread)));
                    },
                    child: _buildUI(
                      context: context,
                      thread: thread,
                      authorNickName: contactData.nickname,
                      avatarLink: contactData.avatarLink,
                    ));
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
                    builder: (context) => ComposePostScreen(threads[index])));
          },
          child: _buildThreadSummary(threads[index], index),
        );
      },
    );
  }
}
