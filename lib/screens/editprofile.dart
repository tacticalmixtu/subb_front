import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/editprofile';
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
            child: EditProfileForm(),
          ),
        ),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends State<EditProfileForm> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final schoolController = TextEditingController();
  final bioController = TextEditingController();

  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      nameController,
      usernameController,
      schoolController,
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

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Edit Profile', style: Theme.of(context).textTheme.headline4),
          Padding(padding: EdgeInsets.all(8.0)),

          Container(
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP8UGUq_Z0Tn5u4gqDgXlffUaKu2Cm1Hcedw&usqp=CAU"),//image url here
              radius: 60.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration:
              InputDecoration(hintText: 'Nickname'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: usernameController,
              decoration:
              InputDecoration(hintText: 'Username'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: schoolController,
              decoration: InputDecoration(hintText: 'School/Department'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: bioController,
              decoration: InputDecoration(hintText: 'Bio/About me'),
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),

          TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled)
                            ? null
                            : Colors.blue;
                      }),
                  backgroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) =>
                      states.contains(MaterialState.disabled)
                          ? null
                          : Colors.deepOrangeAccent)),
              onPressed: formProgress == 1 ? popCurrentPage : null,
              child: Text("Save")),
          Padding(padding: EdgeInsets.all(8.0)),
          TextButton(
              style: ButtonStyle(
                foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.blue),
                backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.deepOrangeAccent),
              ),
              onPressed: popCurrentPage,
              child: Text("Cancel")),
        ]));
  }
}
