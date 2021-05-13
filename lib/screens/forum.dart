import 'package:flutter/material.dart';
import 'package:subb_front/models/thread.dart';

class ForumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Thread>>(
      future: fetchThreads('1', '1'),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          print('ForumScreen FutureBuilder ${snapshot.error}');

        return snapshot.hasData
            ? ThreadsList(threads: snapshot.data!)
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ThreadsList extends StatelessWidget {
  final List<Thread> threads;

  ThreadsList({Key? key, required this.threads}) : super(key: key);

  Widget _buildCard(String title, int author) => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text(title),
                subtitle: Text('$author'),
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
        return _buildCard(threads[index].title, threads[index].author);
      },
    );
  }
}
