import 'package:flutter/material.dart';
import 'package:subb_front/models/thread.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<Thread>> _futureThreads;

  @override
  void initState() {
    super.initState();
    _futureThreads = fetchThreads('1', '1');
  }

  void _updateThreads() async {
    setState(() {
      _futureThreads = fetchThreads('1', '1');
    });
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
                return ThreadsPage(threads: snapshot.data!);
                // });
              }
          }
        });
  }
}

class ThreadsPage extends StatelessWidget {
  final List<Thread> threads;
  ThreadsPage({Key? key, required this.threads});

  Widget _buildCard(String title, int author) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(title),
                subtitle: Text('$author'),
                // Image.network(photos[index].thumbnailUrl);
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return _buildCard(threads[index].title, threads[index].author);
    });
  }
}
