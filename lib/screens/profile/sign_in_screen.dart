import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
import 'package:subb_front/screens/profile/reset_password_screen.dart';
import 'package:subb_front/utils/api_collection.dart';

class SigninScreen extends StatelessWidget {
  static const routeName = '/sign_in';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(child: SigninForm()),
    );
  }
}

class SigninForm extends StatefulWidget {
  @override
  SigninFormState createState() => SigninFormState();
}

class SigninFormState extends State<SigninForm> {
  late final _emailController;
  late final _passwordController;

  late bool _hidePassword;
  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _hidePassword = true;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _emailController,
      _passwordController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
      setState(() {
        formProgress = progress;
      });
    }
  }

  void navigateToResetPassword() {
    Navigator.pushNamed(context, ResetPasswordScreen.routeName);
  }

  void _signIn() async {
    final apiResponse = await signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    late final SnackBar snackBar;
    if (apiResponse.code == 200) {
      Provider.of<SignInState>(context, listen: false).signIn();
      snackBar = SnackBar(content: Text('Signed in successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else if (apiResponse.code == 401) {
      snackBar = SnackBar(content: Text('Email and password do not match'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (apiResponse.code == 402) {
      snackBar = SnackBar(content: Text('Email does not exist'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: updateFormProgress,
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _emailController,
              maxLength: 20,
              validator: (value) {
                RegExp regex = RegExp(
                    r'^([_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{1,6}))$');
                if (value == null || value.length == 0) {
                  return 'Please enter your email';
                } else if (!regex.hasMatch(value)) {
                  return 'Incorrect email address';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              maxLength: 20,
              obscureText: _hidePassword,
              validator: (value) {
                RegExp lengthRule = RegExp(r'.{6,16}');
                RegExp letterRule = RegExp(r'[A-Za-z]');
                RegExp digitRule = RegExp(r'\d');

                if (value == null || value.length == 0) {
                  return 'Please enter your password';
                }
                if (!lengthRule.hasMatch(value)) {
                  return 'Incorrect password format';
                }
                if (!letterRule.hasMatch(value)) {
                  return 'Incorrect password format';
                }
                if (!digitRule.hasMatch(value)) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LimitedBox(
                  child: TextButton(
                    onPressed: navigateToResetPassword,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B72D7)),
                    ),
                  ),
                ),
                LimitedBox(
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
                      child: Text("Sign in")),
                ),
              ],
            ),
          ])),
    );
  }
}
