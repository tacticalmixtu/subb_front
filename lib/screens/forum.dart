// import 'package:flutter/material.dart';
// import 'package:subb_front/screens/appbar.dart';

// class ForumScreen extends StatelessWidget {
//   final List<Photo> photos;

//   PhotosList({Key? key, required this.photos}) : super(key: key);
//   Widget _buildCard() => Container(
//         margin: EdgeInsets.all(4),
//         child: Card(
//           child: Column(
//             children: [
//               const ListTile(
//                 leading: Icon(Icons.album),
//                 title: Text('The Enchanted Nightingale'),
//                 subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//               ),
//             ],
//           ),
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         // return Image.network(photos[index].thumbnailUrl);
//         // return Text('${photos[index].title}');
//         return _buildCard();
//       },
//     );
//   }
// }
