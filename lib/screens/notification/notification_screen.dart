import 'package:flutter/material.dart';
import 'package:subb_front/screens/notification/message_screen.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Updates', icon: Icon(Icons.campaign)),
                Tab(text: 'Private Messages', icon: Icon(Icons.chat)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Text('subsrcibtion feeds'),
              ChatScreen(),
            ],
          ),
        ));
  }
}
