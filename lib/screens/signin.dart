import 'package:flutter/material.dart';
//import 'signup.dart';

class SigninScreen extends StatelessWidget {
  static const routeName = '/signin';
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
            child: SigninForm(),
          ),
        ),
      ),
    );
  }
}

class SigninForm extends StatefulWidget {
  @override
  SigninFormState createState() => SigninFormState();
}

class SigninFormState extends State<SigninForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [usernameController, passwordController];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }

      setState(() {
        formProgress = progress;
      });
    }
  }

  void showWelcomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext) {
      return Scaffold(
        appBar: AppBar(
          title: Text("You are signed in."),
        ),
      );
    }));
  }

  void showSignUpScreen() {
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => new SignUpScreen()));
    //Navigator.of(context).pop();
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Sign In', style: Theme.of(context).textTheme.headline4),
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
              onPressed: formProgress == 1 ? showWelcomeScreen : null,
              child: Text("Sign In")),
          Padding(padding: EdgeInsets.all(8.0)),
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Text("New User?",
                style: TextStyle(fontSize: 16.0, color: Colors.deepOrange)),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.blue),
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.deepOrangeAccent),
              ),
              onPressed: showSignUpScreen,
              child: Text("Sign Up")),
        ]));
  }
}
