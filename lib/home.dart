// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:subb_front/appbar.dart';
import 'package:subb_front/model/photo.dart';
import 'package:http/http.dart' as http;
import 'package:subb_front/model/album.dart';

class HomePage extends StatelessWidget {
  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(),
      // body: ListView(
      //   children: [
      //     _buildCard(),
      //     Divider(),
      //     _buildCard(),
      //   ],
      // ),
      drawer: ForumDrawer(),
      body: Center(
        child: FutureBuilder<List<Photo>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? PhotosList(photos: snapshot.data!)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key? key, required this.photos}) : super(key: key);
  Widget _buildCard() => SizedBox(
        height: 210,
        child: Card(
          child: Column(
            children: [
              // ListTile(
              //   title: Text('1625 Main Street',
              //       style: TextStyle(fontWeight: FontWeight.w500)),
              //   subtitle: Text('My City, CA 99984'),
              //   leading: Icon(
              //     Icons.restaurant_menu,
              //     color: Colors.blue[500],
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   title: Text('(408) 555-1212',
              //       style: TextStyle(fontWeight: FontWeight.w500)),
              //   leading: Icon(
              //     Icons.contact_phone,
              //     color: Colors.blue[500],
              //   ),
              // ),
              // ListTile(
              //   title: Text('costa@example.com'),
              //   leading: Icon(
              //     Icons.contact_mail,
              //     color: Colors.blue[500],
              //   ),
              // ),
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${photos[index].title}');
        return _buildCard();
      },
    );
  }
}

class ForumList extends StatelessWidget {
  final List<Album> albums;

  ForumList({Key? key, required this.albums}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        // return Image.network(photos[index].thumbnailUrl);
        // return Text('${albums[index].title}');
        return ListTile(
          title: Text('${albums[index].title}'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
// class Albums extends StatefulWidget {
//   @override
//   _AlbumsState createState() => _AlbumsState();
// }

// class _AlbumsState extends State<Albums> {
//   late Future<Album> futureAlbum;

//   @override
//   void initState() {
//     super.initState();
//     futureAlbum = fetchAlbum();
//   }

//   @override
//   Widget build(BuildContext context) => FutureBuilder<Album>(
//         future: futureAlbum,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Text(snapshot.data!.title);
//           } else if (snapshot.hasError) {
//             return Text("${snapshot.error}");
//           }

//           // By default, show a loading spinner.
//           return CircularProgressIndicator();
//         },
//       );
// }

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
      //ListView(
      // Important: Remove any padding from the ListView.
      //padding: EdgeInsets.zero,
      // children: <Widget>[
      //   DrawerHeader(
      //     child: Text('Forum sections'),
      //     decoration: BoxDecoration(
      //       color: Colors.blue,
      //     ),
      //   ),
      //   ListTile(
      //     title: Text('First section'),
      //     onTap: () {
      //       // Update the state of the app.
      //       // ...
      //       Navigator.pop(context);
      //     },
      //   ),
      //   ListTile(
      //     title: Text('Another section'),
      //     onTap: () {
      //       // Update the state of the app.
      //       // ...
      //       Navigator.pop(context);
      //     },
      //   ),
      // ],
      // children: <Widget>[
      //   DrawerHeader(
      //     child: Text('Forum sections'),
      //     decoration: BoxDecoration(
      //       color: Colors.blue,
      //     ),
      //   ),

      // ],
      // ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   HomePage({Key? key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppbar(),
//       // body: Center(
//       //   child: Column(
//       //     // Invoke "debug painting" (press "p" in the console, choose the
//       //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
//       //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//       //     // to see the wireframe for each widget.
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: <Widget>[
//       //       Text(
//       //         'You have pushed the button this many times:',
//       //       ),
//       //       Text(
//       //         '$_counter',
//       //         style: Theme.of(context).textTheme.headline4,
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//       // body: Thread(),
//     );
//   }
// }

// class Thread extends StatelessWidget {
//   ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
//         title: Text(title,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 20,
//             )),
//         subtitle: Text(subtitle),
//         leading: Icon(
//           icon,
//           color: Colors.blue[500],
//         ),
//       );
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
//         _tile('The Castro Theater', '429 Castro St', Icons.theaters),
//         _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
//         _tile('Roxie Theater', '3117 16th St', Icons.theaters),
//         _tile('United Artists Stonestown Twin', '501 Buckingham Way',
//             Icons.theaters),
//         _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
//         Divider(),
//         _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
//         _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
//         _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
//         _tile('La Ciccia', '291 30th St', Icons.restaurant),
//       ],
//     );
//   }
// }

// class TrendingCarousel extends StatefulWidget {
//   const TrendingCarousel({Key? key, required this.children}) : super(key: key);

//   final List<Widget> children;

//   @override
//   _TrendingCarouselState createState() => _TrendingCarouselState();
// }

// class _TrendingCarouselState extends State<TrendingCarousel> {
//   static const cardPadding = 15.0;
//   ScrollController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = ScrollController();
//     _controller.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _builder(int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//         horizontal: cardPadding,
//       ),
//       child: widget.children[index],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var showPreviousButton = false;
//     // var showNextButton = true;
//     // Only check this after the _controller has been attached to the ListView.
//     if (_controller.hasClients) {
//       showPreviousButton = _controller.offset > 0;
//       showNextButton =
//           _controller.offset < _controller.position.maxScrollExtent;
//     }
//     final totalWidth = MediaQuery.of(context).size.width -
//         (_horizontalDesktopPadding - cardPadding) * 2;
//     final itemWidth = totalWidth / _desktopCardsPerPage;

//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: _horizontalDesktopPadding - cardPadding,
//           ),
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             physics: const _SnappingScrollPhysics(),
//             controller: _controller,
//             itemExtent: itemWidth,
//             itemCount: widget.children.length,
//             itemBuilder: (context, index) => _builder(index),
//           ),
//         ),
//         // if (showPreviousButton)
//         //   _DesktopPageButton(
//         //     onTap: () {
//         //       _controller.animateTo(
//         //         _controller.offset - itemWidth,
//         //         duration: const Duration(milliseconds: 200),
//         //         curve: Curves.easeInOut,
//         //       );
//         //     },
//         //   ),
//         // if (showNextButton)
//         //   _DesktopPageButton(
//         //     isEnd: true,
//         //     onTap: () {
//         //       _controller.animateTo(
//         //         _controller.offset + itemWidth,
//         //         duration: const Duration(milliseconds: 200),
//         //         curve: Curves.easeInOut,
//         //       );
//         //     },
//         //   ),
//       ],
//     );
//   }
// }

// class _CarouselCard extends StatelessWidget {
//   const _CarouselCard({
//     Key key,
//     this.demo,
//     this.asset,
//     this.assetDark,
//     this.assetColor,
//     this.assetDarkColor,
//     this.textColor,
//     this.studyRoute,
//   }) : super(key: key);

//   final GalleryDemo demo;
//   final ImageProvider asset;
//   final ImageProvider assetDark;
//   final Color assetColor;
//   final Color assetDarkColor;
//   final Color textColor;
//   final String studyRoute;

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
//     final asset = isDark ? assetDark : this.asset;
//     final assetColor = isDark ? assetDarkColor : this.assetColor;
//     final textColor = isDark ? Colors.white.withOpacity(0.87) : this.textColor;

//     return Container(
//       // Makes integration tests possible.
//       key: ValueKey(demo.describe),
//       margin:
//           EdgeInsets.all(isDisplayDesktop(context) ? 0 : _carouselItemMargin),
//       child: Material(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context).restorablePushNamed(studyRoute);
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               if (asset != null)
//                 FadeInImagePlaceholder(
//                   image: asset,
//                   placeholder: Container(
//                     color: assetColor,
//                   ),
//                   child: Ink.image(
//                     image: asset,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       demo.title,
//                       style: textTheme.caption.apply(color: textColor),
//                       maxLines: 3,
//                       overflow: TextOverflow.visible,
//                     ),
//                     Text(
//                       demo.subtitle,
//                       style: textTheme.overline.apply(color: textColor),
//                       maxLines: 5,
//                       overflow: TextOverflow.visible,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
