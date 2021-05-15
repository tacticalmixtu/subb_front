import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final currentItemIndex;
  final void Function(int index) callbackOnTap;

  HomeBottomNavigationBar(
      {Key? key, required this.callbackOnTap, required this.currentItemIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (int index) {
        callbackOnTap(index);
      },
      currentIndex: currentItemIndex,
      items: [
        BottomNavigationBarItem(
          label: 'Forums',
          icon: Icon(Icons.forum),
        ),
        BottomNavigationBarItem(
            label: 'Notifications',
            icon: Badge(
              // TODO: dynamic number
              badgeContent: Text('12'),
              child: Icon(Icons.notifications),
              padding: EdgeInsets.all(4),
              animationType: BadgeAnimationType.scale,
            )),
        BottomNavigationBarItem(
          label: 'Me',
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}
