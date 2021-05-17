import 'package:flutter/material.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/utils/api_collection.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/edit_profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(child: EditProfileForm()),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends State<EditProfileForm> {
  late final _nameController;
  late final _passwordController;
  late final _genderController;
  late final _bioController;

  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _genderController = TextEditingController();
    _bioController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _genderController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _nameController,
      _passwordController,
      _genderController,
      _bioController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 0.25;
      }

      setState(() {
        formProgress = progress;
      });
    }
  }

  void _modifyInfo() async {
    final apiResponse = await modifyInfo(
      nickname: _nameController.text,
      password: _passwordController.text,
      // gender: genderController.text,
      // avatarLink : 'https://peinanweng.com/download_index/base/avatar.png',
      personalInfo: _bioController.text,
    );
    late final SnackBar snackBar;
    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Profile Saved'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      snackBar = SnackBar(content: Text('Profile Saving Failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<ApiResponse> _futureResponse = loadSelf();
    return Form(
        key: _formKey,
        onChanged: updateFormProgress,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                  onTap: () {
                    // Todo: Upload Avatar & Save Avatar
                  },
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
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final ContactData selfData = ContactData.fromJson(
                                  snapshot.data!.data! as dynamic);
                              return CircleAvatar(
                                backgroundImage:
                                    NetworkImage(selfData.avatarLink),
                                radius: 40.0,
                              );
                            }
                        }
                      })),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nickname'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'About Me'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  LimitedBox(
                    child:
                        TextButton(onPressed: _modifyInfo, child: Text("Save")),
                  ),
                ],
              )
            ])));
  }
}
