import 'package:flutter/material.dart';
import 'package:subb_front/screens/notification/chat.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.campaign)),
              Tab(icon: Icon(Icons.chat)),
            ],
          ),
          title: Text('Notifications'),
        ),
        body: TabBarView(
          children: [
            Text('subsrcibtion feeds'),
            ChatScreen(),
          ],
        ),
      ),
    );
  }
}
