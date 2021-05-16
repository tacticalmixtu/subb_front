import 'package:flutter/material.dart';
import 'package:subb_front/screens/notification/chat.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen();
  @override
  Widget build(BuildContext context) {
    // TabController(vsync: tickerProvider, length: tabCount)
    //   ..addListener(() {
    //     if (!tabController.indexIsChanging) {
    //       setState(() {
    //         // Rebuild the enclosing scaffold with a new AppBar title
    //         appBarTitle = 'Tab ${tabController.index}';
    //       });
    //     }
    //   });
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('SUBB'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.campaign)),
                Tab(icon: Icon(Icons.chat)),
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
