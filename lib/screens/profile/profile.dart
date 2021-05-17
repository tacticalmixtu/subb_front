import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/profile/sign_in.dart';
import 'package:subb_front/screens/profile/sign_up.dart';
import 'package:subb_front/screens/profile/user.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return Consumer<SignInState>(
      builder: (context, signInState, child) {
        if (!signInState.isSignedIn) {
          return Empty();
        } else {
          return UserProfileScreen();
        }
      },
    );
  }
}

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Icon(
                Icons.highlight_outlined,
                size: 36,
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                'Sign in to explore more',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Spacer(flex: 1),
            Flexible(
              flex: 2,
              child: ElevatedButton.icon(
                  // style: ButtonStyle(minimumSize: ),
                  onPressed: () {
                    Navigator.pushNamed(context, SigninScreen.routeName);
                  },
                  icon: Icon(Icons.login),
                  label: Text('sign in')),
            ),
            Flexible(
              flex: 4,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.routeName);
                },
                child: Text(
                  "Not having an account? Register one with your SUmail",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
