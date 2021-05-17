import 'package:flutter/material.dart';

class HomeAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _HomeAppbarState createState() => _HomeAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      elevation: 4.0,
    );
  }
}
