import 'package:flutter/material.dart';
import 'package:subb_front/screens/home/bottom_navi_bar.dart';
import 'package:subb_front/screens/forum/forum.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _contentPageIndex = 0;

  final _contentPages = <Widget>[
    ForumScreen(forumId: 1),
    Center(
      child: Text('Implement notification screen'),
    ),
    Center(
      child: Text('Implement Personal info screen'),
    ),
  ];
  void _handleBottomBarItemTapped(int index) {
    setState(() {
      _contentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: render different layout for web/android
      body: SafeArea(
        child: _contentPages[_contentPageIndex],
      ),

      bottomNavigationBar: HomeBottomNavigationBar(
        callbackOnTap: _handleBottomBarItemTapped,
        currentItemIndex: _contentPageIndex,
      ),
    );
  }
}
