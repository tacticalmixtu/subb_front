import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/home/home.dart';
import 'package:subb_front/screens/me/me_screen.dart';
import 'package:subb_front/screens/me/signin.dart';
import 'package:subb_front/screens/me/signup.dart';
import 'package:subb_front/screens/me/editprofile.dart';
import 'package:subb_front/screens/me/userprofile.dart';
import 'package:subb_front/screens/me/resetpassword.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => SignInState(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUBB',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Color(0xFFF76900),
        accentColor: Color(0xFF2B72D7),

        // Define the default font family.
        // fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Sherman'),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (BuildContext context) => HomeScreen(),
        SigninScreen.routeName: (BuildContext context) => SigninScreen(),
        SignUpScreen.routeName: (BuildContext context) => SignUpScreen(),
        UserProfileScreen.routeName: (BuildContext context) =>
            UserProfileScreen(),
        ResetPasswordScreen.routeName: (BuildContext context) =>
            ResetPasswordScreen(),
        EditProfileScreen.routeName: (BuildContext context) =>
            EditProfileScreen(),
        MeScreen.routeName: (BuildContext context) => MeScreen(),
      },
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// TODO:
// Rich-text editor
// data pulling/process
// test data gathering
