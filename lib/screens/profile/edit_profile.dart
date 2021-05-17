import 'package:flutter/material.dart';
import 'package:subb_front/utils/api_collection.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/edit_profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
      ),
      body: EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends State<EditProfileForm> {
  late final nameController;
  late final passwordController;
  late final genderController;
  late final bioController;

  @override
  void initState() {
    nameController = TextEditingController();
    passwordController = TextEditingController();
    genderController = TextEditingController();
    bioController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    genderController.dispose();
    bioController.dispose();
    super.dispose();
  }

  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      nameController,
      passwordController,
      genderController,
      bioController
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

  void popCurrentPage() {
    Navigator.of(context).pop();
  }

  void _modifyInfo() async {
    final apiResponse = await modifyInfo(
      nickname: nameController.text,
      password: passwordController.text,
      // gender: genderController.text,
      // avatarLink : 'https://peinanweng.com/download_index/base/avatar.png',
      personalInfo: bioController.text,
    );
    late final SnackBar snackBar;
    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Saved'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    snackBar = SnackBar(content: Text('Save failed'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //Navigator.pop(context);
  }

  /*
  void _loadSelf() async {

    final _loadSelfApi = '/small_talk_api/load_self';
    final apiResponse = await doGet(_loadSelfApi, null);

    //final apiResponse = await Uri.https('smalltalknow.com', _loadSelfApi, {});

    late final SnackBar snackBar;
    if (apiResponse != null) {
      print('code: ${apiResponse.code}');
      print('message: ${apiResponse.message}');
      print('data: ${apiResponse.data}');

      if (apiResponse.code == 200) {
        print('200');
        snackBar = SnackBar(content: Text('Profile loaded'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }
    print('not 200');
    snackBar = SnackBar(content: Text('Load profile failed'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
  */

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: updateFormProgress,
        child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit Profile',
                  style: Theme.of(context).textTheme.headline5),
              Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8UGUq_Z0Tn5u4gqDgXlffUaKu2Cm1Hcedw&usqp=CAU"), //image url here
                  radius: 40.0,
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: ' Nickname'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: ' Password'),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(
                    labelText: ' Gender',
                    helperText: ' E.g. male, female, others, hidden'),
              ),
              TextFormField(
                controller: bioController,
                decoration: InputDecoration(labelText: ' About me'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                      //onPressed: formProgress == 1 ? popCurrentPage : null,
                      onPressed: _modifyInfo,
                      child: Text("Save")),
                  TextButton(onPressed: popCurrentPage, child: Text("Cancel")),
                  //TextButton(
                  //    onPressed: _loadSelf,
                  //    child: Text("Load Self")),
                ],
              )
            ]));
  }
}
