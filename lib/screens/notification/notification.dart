import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            Text('private messages'),
          ],
        ),
      ),
    );
  }
}
