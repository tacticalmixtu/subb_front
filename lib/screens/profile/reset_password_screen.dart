import 'package:flutter/material.dart';
import 'package:subb_front/utils/api_collection.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = '/reset_password';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: ResetForm(),
    );
  }
}

class ResetForm extends StatefulWidget {
  @override
  ResetFormState createState() => ResetFormState();
}

class ResetFormState extends State<ResetForm> {
  final _resetPasswordApi = '/small_talk_api/recover_password/';
  final _requestPasscodeApi = '/small_talk_api/request_passcode/';

  late bool _hidePassword;
  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();
  double PADDING_SIZE = 10.0;

  late final _emailController;
  late final _passwordController;
  late final _passcodeController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passcodeController = TextEditingController();
    _hidePassword = true;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _emailController,
      _passwordController,
      _passcodeController
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

  void _requestPasscode() async {
    final apiResponse = await requestPasscode(email: _emailController.text);
    late final SnackBar snackBar;
    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Verification code sent'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    } else {
      snackBar = SnackBar(content: Text('Unable to send verification code'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  void _reset() async {
    final apiResponse = await recoverPassword(
        email: _emailController.text,
        password: _passwordController.text,
        passcode: _passcodeController.text);
    late final SnackBar snackBar;
    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Reset password success'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      return;
    } else {
      snackBar = SnackBar(content: Text('Reset Password failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Reset password', style: Theme.of(context).textTheme.headline5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: PADDING_SIZE),
            child: TextFormField(
              controller: _emailController,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'SUmail',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
              ),
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
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _requestPasscode();
                    }
                  },
                  //onPressed: _requestPasscode,
                  child: Text(
                    "    Send verification code",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: PADDING_SIZE),
            child: TextFormField(
              controller: _passcodeController,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Enter your code',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: PADDING_SIZE),
            // TODO: use password hidden
            child: TextFormField(
              controller: _passwordController,
              maxLength: 20,
              obscureText: _hidePassword,
              validator: (value) {
                //validate password
                RegExp hasUpper = RegExp(r'[A-Z]');
                RegExp hasLower = RegExp(r'[a-z]');
                RegExp hasDigit = RegExp(r'\d');

                if (value == null || value.length == 0) {
                  return 'Please enter your password';
                }
                if (!RegExp(r'.{2,}').hasMatch(value)) {
                  return 'Password must have at least 2 characters';
                }
                if (!hasUpper.hasMatch(value)) {
                  return 'Password must have at least one uppercase letter';
                }
                if (!hasLower.hasMatch(value)) {
                  return 'Password must have at least one lowercase letter';
                }
                if (!hasDigit.hasMatch(value)) {
                  return 'Password must have at least one number';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Create your new password',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                helperText:
                    'Password should contain numbers, uppercase letters and lowercase letters. No special characters. Length: 2-16.', // Length: 2-16',
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
                  child:
                      Padding(padding: EdgeInsets.symmetric(horizontal: 1.0))),
              Expanded(
                  child:
                      Padding(padding: EdgeInsets.symmetric(horizontal: 1.0))),
              Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                          return states.contains(MaterialState.disabled)
                              ? null
                              : Colors.white; //Color(0xFF2B72D7);
                        }),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) =>
                                states.contains(MaterialState.disabled)
                                    ? null
                                    : Color(0xFFF76900))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _reset();
                      }
                    },
                    //_signUp
                    child: Text("Reset password")),
              ),
            ],
          ),
        ]));
  }
}
