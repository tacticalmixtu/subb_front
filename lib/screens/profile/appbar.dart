import 'package:flutter/material.dart';

class ProfileAppbar extends StatefulWidget with PreferredSizeWidget {
  @override
  _ProfileAppbarState createState() => _ProfileAppbarState();

  @override
  // Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0))
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('User Profile'),
      elevation: 4.0,
    );
  }
}
