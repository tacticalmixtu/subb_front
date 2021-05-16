import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:subb_front/models/album.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/screens/forum/appbar.dart';
import 'package:subb_front/screens/forum/compose.dart';
import 'package:subb_front/screens/forum/thread.dart';

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
    return Scaffold(
      appBar: ForumAppbar(),
      drawer: ForumDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ComposeScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Thread>>(
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
          }),
    );
  }
}

class ThreadsPage extends StatelessWidget {
  final List<Thread> threads;
  ThreadsPage({Key? key, required this.threads});

  String _toDT(int epoch) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return '${dt.month}/${dt.day}/${dt.year} ${dt.hour}:${dt.minute}';
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
        child: Card(
          child: Column(
            children: [
              ListTile(
                // return Image.network(photos[index].thumbnailUrl);
                // return Text('${photos[index].title}');
                leading: new Icon(Icons.person_pin, size: 40.0),
                title: Text('${thread.title}'),
                subtitle: Text('User ID - ${thread.author}'),
                trailing: Column(
                  children: [
                    Text('${_toDT(thread.activeTimestamp)}'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 192),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconItem(Icons.whatshot, '${thread.heat}'),
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

class ForumDrawer extends StatelessWidget {
  const ForumDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<Album>>(
        future: fetchAlbums(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ForumList(albums: snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
