import 'package:flutter/material.dart';
import 'package:subb_front/screens/me/signin.dart';

class MeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(96),
        child: Empty(),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('No account on this device'),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, SigninScreen.routeName);
            },
            icon: Icon(Icons.login),
            label: Text('sign in')),
      ],
    );
  }
}
