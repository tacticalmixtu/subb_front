import 'package:flutter/material.dart';
import 'package:subb_front/screens/appbar.dart';

class ThreadScreen extends StatelessWidget {
  static const routeName = '/threads';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          // Respond to button press
          print("reply to current new post");
        },
        child: Icon(Icons.reply),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _tile("conent", "subtitle", Icons.person),
            Divider(),
            _tile("conent", "subtitle", Icons.person),
            Divider(),
            _tile("conent", "subtitle", Icons.person),
            Divider(),
          ],
        ),
      ),
    );
  }
}
