import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/me/signin.dart';
import 'package:subb_front/screens/me/userprofile.dart';

class MeScreen extends StatelessWidget {
  static const routeName = '/me';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Consumer<SignInState>(
      builder: (context, signInState, child) {
        if (!signInState.isSignedIn) {
          return Empty();
        } else {
          return UserProfileScreen();
        }
      },
    ));
  }
}

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('No account on this device'),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, SigninScreen.routeName);
              },
              icon: Icon(Icons.login),
              label: Text('sign in')),
        ],
      ),
    );
  }
}
