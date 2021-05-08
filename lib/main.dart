import 'package:flutter/material.dart';
import 'package:subb_front/home.dart';
import 'package:subb_front/signin.dart';
import 'package:subb_front/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Color(0xFFF76900),
        accentColor: Color(0xFF2B72D7),

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Sherman'),
        ),
      ),
      routes: {
        // '/' :
        '/signin': (BuildContext text) => new LoginScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
      },
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
