import 'package:flutter/material.dart';

class NotificationAppbar extends StatefulWidget with PreferredSizeWidget {
  final TabController tabController;
  NotificationAppbar({required Key? key, required this.tabController});
  @override
  _NotificationAppbarState createState() => _NotificationAppbarState();

  @override
  // Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0))
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NotificationAppbarState extends State<NotificationAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Notifications'),
      elevation: 4.0,
      bottom: TabBar(
        controller: widget.tabController,
        tabs: [
          Tab(icon: Icon(Icons.campaign)),
          Tab(icon: Icon(Icons.chat)),
        ],
      ),
    );
  }
}
