import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/forum/appbar.dart';
import 'package:subb_front/screens/forum/forum.dart';
import 'package:subb_front/screens/home/appbar.dart';
import 'package:subb_front/screens/home/home.dart';
import 'package:subb_front/screens/me/appbar.dart';
import 'package:subb_front/screens/me/me_screen.dart';
import 'package:subb_front/screens/me/signin.dart';
import 'package:subb_front/screens/me/signup.dart';
import 'package:subb_front/screens/me/editprofile.dart';
import 'package:subb_front/screens/me/userprofile.dart';
import 'package:subb_front/screens/me/resetpassword.dart';
import 'package:subb_front/screens/notification/appbar.dart';
import 'package:subb_front/screens/notification/notification.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => SignInState(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUBB',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Color(0xFFF76900),
        accentColor: Color(0xFF2B72D7),

        // Define the default font family.
        // fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Sherman'),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: BaseScaffold.routeName,
      routes: {
        BaseScaffold.routeName: (BuildContext context) => BaseScaffold(),
        HomeScreen.routeName: (BuildContext context) => HomeScreen(),
        SigninScreen.routeName: (BuildContext context) => SigninScreen(),
        SignUpScreen.routeName: (BuildContext context) => SignUpScreen(),
        UserProfileScreen.routeName: (BuildContext context) =>
            UserProfileScreen(),
        ResetPasswordScreen.routeName: (BuildContext context) =>
            ResetPasswordScreen(),
        EditProfileScreen.routeName: (BuildContext context) =>
            EditProfileScreen(),
        MeScreen.routeName: (BuildContext context) => MeScreen(),
      },
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BaseScaffold extends StatefulWidget {
  static final routeName = '/';
  final _pages = <Widget>[
    HomeScreen(),
    ForumScreen(forumId: 1),
    NotificationScreen(),
    MeScreen(),
  ];
  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _currentPageIndex = 0;
  // late final TabController tabController;

  // final _pageAppBars = <PreferredSizeWidget?>[
  //   HomeAppbar(),
  //   ForumAppbar(),
  //   null,
  //   ProfileAppbar(),
  // ];

  @override
  void initState() {
    super.initState();
    // tabController = TabController(length: _pages.length, vsync: this);
  }

  void _handleBottomBarItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: widget._pageAppBars[_currentPageIndex],
      appBar: _currentPageIndex == 2
          ? null
          : AppBar(
              title: Text('SUBB'),
              elevation: 4,
            ),
      body: widget._pages[_currentPageIndex],
      bottomNavigationBar: HomeBottomNavigationBar(
        callbackOnTap: _handleBottomBarItemTapped,
        currentItemIndex: _currentPageIndex,
      ),
    );
  }
}

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
          label: 'Home',
          icon: Icon(Icons.home),
        ),
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
