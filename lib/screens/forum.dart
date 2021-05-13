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

  Widget _buildCard(Thread thread) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(thread.title),
                subtitle: Text('$thread.author'),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => ThreadScreen(thread: threads[index])));
          },
          child: _buildCard(threads[index]),
        ); 
      },
    );
  }
}
