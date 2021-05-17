import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/profile/edit_profile_screen.dart';
import 'package:subb_front/screens/profile/reset_password_screen.dart';
import 'package:subb_front/screens/profile/sign_up_scren.dart';
import 'package:subb_front/utils/api_collection.dart';

class SigninScreen extends StatelessWidget {
  static const routeName = '/sign_in';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(margin: EdgeInsets.all(4), child: SigninForm()),
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

  late bool _hidePassword;
  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  void resetPassword() {
    Navigator.pushNamed(context, ResetPasswordScreen.routeName);
  }

  void navigate() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  void navigateEditProfile() {
    Navigator.pushNamed(context, EditProfileScreen.routeName);
  }

  void _signIn() async {
    final apiResponse = await signIn(
        email: _emailController.text, password: _passwordController.text);

    late final SnackBar snackBar;

    if (apiResponse.code == 200) {
      Provider.of<SignInState>(context, listen: false).signIn();
      snackBar = SnackBar(content: Text('Signed in successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      return;
    } else if (apiResponse.code == 401) {
      snackBar = SnackBar(content: Text('SUmail and password do not match'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else if (apiResponse.code == 402) {
      snackBar = SnackBar(content: Text('SUmail does not exist'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // print("_signIn() error, null apiResponse");
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    snackBar = SnackBar(content: Text('Sign in failed'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Sign in', style: Theme.of(context).textTheme.headline5),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              maxLength: 20,
              validator: (value) {
                //validate email
                RegExp regex =
                    RegExp(r'\w+@\w+\.\w+'); //translates to word@word.word
                if (value == null || value.length == 0) {
                  return 'Please enter your email';
                } else if (!regex.hasMatch(value)) {
                  return 'Incorrect email address';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'SUmail',
                //errorText: 'Invalid Email',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
                //suffixIcon: Icon(Icons.check_circle),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordController,
              maxLength: 20,
              obscureText: _hidePassword,
              validator: (value) {
                //validate password
                RegExp hasLetter = RegExp(r'[A-Za-z]');
                RegExp hasUpper = RegExp(r'[A-Z]');
                RegExp hasLower = RegExp(r'[a-z]');
                RegExp hasDigit = RegExp(r'\d');

                if (value == null || value.length == 0) {
                  return 'Please enter your password';
                }
                if (!RegExp(r'.{2,}').hasMatch(value)) {
                  return 'Incorrect password format';
                }
                if (!hasLetter.hasMatch(value)) {
                  return 'Incorrect password format';
                }
                // if (!hasUpper.hasMatch(value)) {
                //   return 'Incorrect password format';
                // }
                // if (!hasLower.hasMatch(value)) {
                //   return 'Incorrect pas8sword format';
                // }
                if (!hasDigit.hasMatch(value)) {
                  return 'Incorrect password format';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: resetPassword,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.all(4.0)),
              ),
              Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                          return states.contains(MaterialState.disabled)
                              ? null
                              : Colors.white;
                        }),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) =>
                                states.contains(MaterialState.disabled)
                                    ? null
                                    : Color(0xFFF76900))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      }
                    },
                    //onPressed: _signIn,
                    child: Text("Sign in")),
              ),
            ],
          ),
        ]));
  }
}
