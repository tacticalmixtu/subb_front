import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/userprofile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: UserProfileForm(),
          ),
        ),
      ),
    );
  }
}

class UserProfileForm extends StatefulWidget {
  @override
  UserProfileFormState createState() => UserProfileFormState();
}

class UserProfileFormState extends State<UserProfileForm> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final schoolController = TextEditingController();
  final bioController = TextEditingController();

  double formProgress = 0;

  void popCurrentPage() {
    //Navigator.pushNamed(context, '/signin');
    Navigator.of(context).pop();
  }

  void showEditProfileScreen() {
    //Navigator.pushNamed(context, '/editprofile');
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => new EditProfileScreen()));

    Navigator.pushNamed(context, '/editprofile');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('My Profile', style: Theme.of(context).textTheme.headline4),
          Padding(padding: EdgeInsets.all(8.0)),

          Container(
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8UGUq_Z0Tn5u4gqDgXlffUaKu2Cm1Hcedw&usqp=CAU"),//image url here
              radius: 60.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Alice, EECS"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Username: milano987"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Bio: MSCS 19 Fall. Enjoy traveling and skiing!"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.blue),
                backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.transparent),
              ),
              onPressed: showEditProfileScreen,
              child: Text("Edit Profile")),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
        ]));
  }
}
