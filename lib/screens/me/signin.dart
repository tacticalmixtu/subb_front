import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subb_front/models/sign_in_state.dart';
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

  late bool _hidePassword;
  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _hidePassword = true;
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
    Navigator.pushNamed(context, '/resetpassword');
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
      if (apiResponse.code == 200) {
        Provider.of<SignInState>(context, listen: false).signIn();
        snackBar = SnackBar(content: Text('Signed in successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
        return;
      } else if (apiResponse.code == 401) {
        snackBar = SnackBar(content: Text('SUmail and password do not match.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else if (apiResponse.code == 402) {
        snackBar = SnackBar(content: Text('SUmail does not exist'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
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
        //key: _formKey,
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Sign in', style: Theme.of(context).textTheme.headline5),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              maxLength: 20,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length <= 6) {
                  return 'Invalid email';
                }
                return null;
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
            // TODO: use password hidden
            child: TextFormField(
              controller: _passwordController,
              maxLength: 20,
              obscureText: _hidePassword,
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
                    //onPressed: formProgress == 1 ? _signIn : null,
                    onPressed: _signIn,
                    child: Text("Sign in")),
              ),
            ],
          ),
        ]));
  }
}
/*
//import 'package:flutter/cupertino.dart';
TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Color(0xFF2B72D7);
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) =>
                          states.contains(MaterialState.disabled)
                              ? null
                              :Color(0xFFF76900))),
               //onPressed: formProgress == 1 ? _signIn : null,
              onPressed: _signIn,
              child: Text("Sign In")),
          Padding(padding: EdgeInsets.all(8.0)),
          TextButton(
              onPressed: showResetScreen,
              child: Text("Forgot email?", style: TextStyle(color: Color(0xFF2B72D7)),)),*/
