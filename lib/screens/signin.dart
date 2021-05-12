import 'package:flutter/material.dart';
import 'package:subb_front/screens/home.dart';
import 'package:subb_front/utils/network.dart';

class SigninScreen extends StatelessWidget {
  static const routeName = '/signin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
      ),
      body: SigninForm(),
    );
  }
}

class SigninForm extends StatefulWidget {
  @override
  SigninFormState createState() => SigninFormState();
}

class SigninFormState extends State<SigninForm> {
  final _signInApi = '/small_talk_api/sign_in/';
  late final _emailController;
  late final _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [_emailController, _passwordController];

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
    Navigator.pushNamed(context, '/userprofile');
    /*
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext) {
      return Scaffold(
        appBar: AppBar(
          title: Text("You are signed in."),
        ),
      );
    }));*/
  }

  void showSignUpScreen() {
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => new SignUpScreen()));
    //Navigator.of(context).pop();
    Navigator.pushNamed(context, '/signup');
  }

  void _signIn() async {
    final apiResponse = await doPost(
      _signInApi,
      {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
      null,
    );
    late final SnackBar snackBar;
    if (apiResponse != null) {
      // print('code: ${apiResponse.code}');
      // print('message: ${apiResponse.message}');
      // print('data: ${apiResponse.data}');
      snackBar = SnackBar(content: Text('Signed in success'));
    } else {
      snackBar = SnackBar(content: Text('Signed in failed'));
      // print("_signIn() error, null apiResponse");
    }

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context);
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
              controller: _emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            // TODO: use password hidden
            child: TextFormField(
              controller: _passwordController,
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
              // onPressed: formProgress == 1 ? showWelcomeScreen : _signIn,
              onPressed: _signIn,
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
