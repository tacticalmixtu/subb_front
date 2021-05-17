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

  // Widget _buildIconItem(String label, String content) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 4.0),
  //     child: Row(
  //       children: [
  //         Text(label),
  //         Text(content),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBottomContainer(Thread thread) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             // _buildIconItem(Icons.whatshot, '${thread.heat}'),
  //             _buildIconItem('Posts: ', '${thread.posts}'),
  //             // _buildIconItem(, '${thread.votes}'),
  //           ],
  //         ),
  //         Text('${epochtoCustomTimeDisplay(thread.activeTimestamp)}'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildUI({required String imageUrl, required Thread thread}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Chip(
                    avatar: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    label: Text('${thread.author}')),
              ),
              Flexible(
                  child: Text(
                '${epochtoCustomTimeDisplay(thread.activeTimestamp)}',
                style: TextStyle(fontSize: 16),
              )),
            ],
          ),
          Text(
            '${thread.title}',
            style: TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Posts: ${thread.posts}',
                style: TextStyle(fontSize: 16),
              ),
              ActionChip(
                avatar: Icon(Icons.thumb_up),
                label: Text("${thread.votes}"),
                onPressed: () {},
              ),
            ],
          ),
          Divider(thickness: 1),
          // ButtonBar(children: [],)
        ],
      ),
    );
  }

  Widget _buildThreadSummary(Thread thread) {
    final Future<ApiResponse> _futureResponse =
        loadUser(userId: thread.author.toString());
    return FutureBuilder<ApiResponse>(
        future: _futureResponse,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              // return _buildUI(image: Icon(Icons.person_pin), thread: thread);
              return Text('Hold on...');
            case ConnectionState.done:
              if (snapshot.hasError) {
                // return _buildUI(
                // image: Icon(Icons.error_outline), thread: thread);
                return Text('Error');
              } else {
                // TODO: change back to real avatar
                return _buildUI(
                    // imageUrl:
                    //     ContactData.fromJson(snapshot.data!.data! as dynamic)
                    //         .avatarLink,
                    imageUrl:
                        r'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201408%2F30%2F20140830180834_XuWYJ.png&refer=http%3A%2F%2Fcdn.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1623856347&t=2586acbfbcd1b632d273a0d4f093344e',
                    thread: thread);
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
          child: _buildThreadSummary(threads[index]),
        );
      },
    );
  }
}
