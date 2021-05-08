import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final suEmailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final verificationCodeController = TextEditingController();

  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      suEmailController,
      usernameController,
      passwordController,
      verificationCodeController
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

  void showLoginScreen() {
    //Navigator.pushNamed(context, '/signin');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        onChanged: updateFormProgress,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.headline4),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: suEmailController,
                  decoration: InputDecoration(hintText: 'Syracuse University Email'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: verificationCodeController,
                  decoration: InputDecoration(hintText: 'Verification Code'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0)
              ),
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Text("A successful Sign Up will make this window pop out.", style: TextStyle(fontSize:  16.0, color: Colors.deepOrange)),
              ),
              TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                        return states.contains(MaterialState.disabled) ? null : Colors.blue;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState>states) => states.contains(MaterialState.disabled) ? null : Colors.deepOrangeAccent)
                  ),
                  onPressed: formProgress == 1 ? showLoginScreen: null,
                  child: Text("Sign Up")
              ),

            ]
        )
    );
  }
}

