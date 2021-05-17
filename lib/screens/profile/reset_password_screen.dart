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
      body: Container(child: ResetForm()),
    );
  }
}

class ResetForm extends StatefulWidget {
  @override
  ResetFormState createState() => ResetFormState();
}

class ResetFormState extends State<ResetForm> {
  late final _emailController;
  late final _passwordController;
  late final _passcodeController;

  late bool _hidePassword;
  double formProgress = 0;
  final _formKey = GlobalKey<FormState>();

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
    } else {
      snackBar = SnackBar(content: Text('Reset Password failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        onChanged: updateFormProgress,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFFF76900)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF76900))),
                ),
                validator: (value) {
                  RegExp regex = RegExp(
                      r'^([_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{1,6}))$');
                  if (value == null || value.length == 0) {
                    return 'Please enter your email';
                  } else if (!regex.hasMatch(value)) {
                    return 'Incorrect email address.';
                  } else {
                    return null;
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LimitedBox(
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _requestPasscode();
                          }
                        },
                        child: Text(
                          "Send Verification Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B72D7)),
                        )),
                  )
                ],
              ),
              TextFormField(
                controller: _passcodeController,
                maxLength: 6,
                validator: (value) {
                  RegExp passcodeRule = RegExp(r'[0-9A-Za-z]{6}$');

                  if (value == null) {
                    return 'Plaese enter your code';
                  }
                  if (!passcodeRule.hasMatch(value)) {
                    return 'Incorrect passcode format';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter your code',
                  labelStyle: TextStyle(color: Color(0xFFF76900)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFF76900))),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                maxLength: 16,
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
                  labelText: 'Create your password',
                  labelStyle: TextStyle(color: Color(0xFFF76900)),
                  helperText:
                      'Must consist of numbers, upper and lower case letters only.',
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
                            _reset();
                          }
                        },
                        child: Text("Reset password")),
                  ),
                ],
              ),
            ])));
  }
}
