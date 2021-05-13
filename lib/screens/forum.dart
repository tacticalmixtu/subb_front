import 'package:flutter/material.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/thread.dart';

// class ForumScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Thread>>(
//       future: fetchThreads('1', '1'),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//           case ConnectionState.active:
//             return Center(child: CircularProgressIndicator());
//           case ConnectionState.done:
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               return ThreadsPage(threads: snapshot.data!);
//             }
//         }
//       },
//     );
//   }
// }

class ForumScreen extends StatefulWidget {
  static const routeName = '/forum';

  final int forumId;

  ForumScreen({Key? key, required this.forumId}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState(forumId);
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<Thread>> _futureThreads;

  final int forumId;

  _ForumScreenState(this.forumId);

  @override
  void initState() {
    super.initState();
    _futureThreads = fetchThreads(forumId.toString(), '1');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Thread>>(
        future: _futureThreads,
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
                // return ListView.builder(itemBuilder: (context, index) {
                return RefreshIndicator(
                  child: ThreadsPage(threads: snapshot.data!),
                  onRefresh: () {
                    setState(() {
                      _futureThreads = fetchThreads('1', '1');
                    });
                    return _futureThreads;
                  },
                );
                // });
              }
          }
        });
  }
}

class ThreadsPage extends StatelessWidget {
  final List<Thread> threads;
  ThreadsPage({Key? key, required this.threads});

  String _toDT(int epoch) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return '${dt.month}/${dt.day}/${dt.year} ${dt.hour}:${dt.minute}:${dt.second}';
  }

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

  Widget _buildCard(Thread thread) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.person_pin,
                  size: 40,
                ),
                title: Text('${thread.title}'),
                subtitle: Text('posted by: ${thread.author}'),
                trailing: Column(
                  children: [
                    // Text('created: ${_toDT(thread.createTimestamp)}'),
                    Text('${_toDT(thread.activeTimestamp)}'),
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.only(left: 192),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconItem(Icons.trending_up, '${thread.heat}'),
                      _buildIconItem(Icons.sms, '${thread.posts}'),
                      _buildIconItem(Icons.thumb_up, '${thread.votes}'),
                    ]),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${photos[index].title}');
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
