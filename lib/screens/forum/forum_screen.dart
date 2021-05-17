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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComposeThreadScreen(forum)));
        },
        icon: Icon(Icons.add),
        label: Text('Compose'),
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

  Widget _buildIconItem(String label, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Text(label),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildBottomContainer(Thread thread) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // _buildIconItem(Icons.whatshot, '${thread.heat}'),
              _buildIconItem('Posts: ', '${thread.posts}'),
              // _buildIconItem(, '${thread.votes}'),
            ],
          ),
          Text('${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
        ],
      ),
    );
  }

  Widget _buildUI({required Widget image, required Thread thread}) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      // margin: EdgeInsets.all(8),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [image, Text('{thread.author}')],
                ),
                Text('${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
              ],
            ),
            Text('${thread.title}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Posts: ${thread.posts}'),
                // Text('Post: ${thread.posts}'),
                ActionChip(
                  avatar: Icon(Icons.thumb_up),
                  label: Text("like!"),
                  onPressed: () {},
                ),
              ],
            )
            // Row(children: [Image.network(avatarUrl),Text('${thread.author'),]),
            // ListTile(
            //   leading: leading,
            //   title: Text('${thread.title}'),
            //   subtitle: Text("User ID - ${thread.author}"),
            //   trailing: ActionChip(
            //     avatar: Icon(Icons.thumb_up),
            //     label: Text("like!"),
            //     onPressed: () {},
            //   ),
            // ),
            // _buildBottomContainer(thread),
          ],
        ),
      ),
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
              return _buildUI(image: Icon(Icons.person_pin), thread: thread);
            case ConnectionState.done:
              return snapshot.hasError
                  ? _buildUI(image: Icon(Icons.error_outline), thread: thread)
                  : _buildUI(
                      image: Image.network(
                          ContactData.fromJson(snapshot.data!.data! as dynamic)
                              .avatarLink),
                      thread: thread);
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
