import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/profile/edit_profile.dart';
import 'package:subb_front/screens/profile/profile.dart';
import 'package:subb_front/utils/api_collection.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/user_profile';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            UserProfileForm(),
            ElevatedButton.icon(
                onPressed: () async {
                  await signOut();
                  Provider.of<SignInState>(context, listen: false).signOut();
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
                icon: Icon(Icons.login),
                label: Text('Sign Out'))
          ],
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
    Navigator.of(context).pop();
  }

  void showEditProfileScreen() {
    Navigator.pushNamed(context, EditProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final Future<ApiResponse> _futureResponse = loadSelf();
    return Form(
      onChanged: null,
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<ApiResponse>(
              future: _futureResponse,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final ContactData selfData =
                          ContactData.fromJson(snapshot.data!.data! as dynamic);
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(selfData.avatarLink),
                            radius: 40.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        Text(selfData.nickname),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        Text(selfData.personalInfo),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.blue),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.transparent),
                            ),
                            onPressed: showEditProfileScreen,
                            child: Text("Edit Profile")),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                      ]);
                    }
                }
              })),
    );
  }
}
