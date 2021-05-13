// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:subb_front/screens/appbar.dart';
import 'package:subb_front/models/photo.dart';
import 'package:http/http.dart' as http;
import 'package:subb_front/models/album.dart';
import 'package:subb_front/screens/forum.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      drawer: ForumDrawer(),
      // TODO: render different layout for web/android
      body: SafeArea(
        child: ForumScreen(),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/compose');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key? key, required this.photos}) : super(key: key);
  Widget _buildCard() => Container(
        margin: EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${photos[index].title}');
        return _buildCard();
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
          // return ForumList(albums: snapshot.data!);
        },
      ),
    );
  }
}
