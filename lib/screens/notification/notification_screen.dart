import 'package:flutter/material.dart';
import 'package:subb_front/screens/notification/message_screen.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen();
  Tab _buildTabItem(IconData icond, String label) {
    return Tab(
        child: Row(
      children: [
        Spacer(
          flex: 4,
        ),
        Icon(icond),
        Spacer(
          flex: 1,
        ),
        Text(label),
        Spacer(
          flex: 4,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications'),
            bottom: TabBar(
              tabs: [
                _buildTabItem(Icons.campaign, "Updates"),
                _buildTabItem(Icons.mail, "Private Messages"),
                // Tab(text: 'Private Messages', icon: Icon(Icons.chat)),
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
