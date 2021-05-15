import 'package:flutter/material.dart';
import 'package:subb_front/utils/network.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
      ),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _signUpApi = '/small_talk_api/sign_up/';
  final _requestPasscodeApi = '/small_talk_api/request_passcode/';

  late final _emailController;
  late final _passwordController;
  late final _passcodeController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passcodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  double formProgress = 0;

  void updateFormProgress() {
    var progress = 0.0;
    final controllers = [ _emailController, _passwordController, _passcodeController ];

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
    final apiResponse = await doPost(
      _requestPasscodeApi,
      {
        'email' : _emailController.text,
      },
      null,
    );

    late final SnackBar snackBar;
    if (apiResponse != null) {
      print('code: ${apiResponse.code}');
      print('messagee: ${apiResponse.message}');
      print('data: ${apiResponse.data}');

      snackBar = SnackBar(content: Text('Passcode requested'));
    } else {
      snackBar = SnackBar(content: Text('Passcode request failed'));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void popScreen() {
    //Navigator.pushNamed(context, '/signin');
    Navigator.of(context).pop();
  }

  int validate() {
    String out;

    late final SnackBar snackBar;

    if (_emailController.text.length < 6) {
      snackBar = SnackBar(content: Text("Invalid email address"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
    if (_passwordController.text.length < 2 || _passwordController.text.length > 16) {
      snackBar = SnackBar(content: Text("Invalid password length"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return -1;
    }
    return 0;
  }

  void _signUp() async {
    if (validate() == 0) {
      final apiResponse = await doPost(
        _signUpApi,
        {
          'email': _emailController.text,
          'password': _passwordController.text,
          'passcode': _passcodeController.text,
        },
        null,
      );

      late final SnackBar snackBar;
      if (apiResponse != null) {
        print('code: ${apiResponse.code}');
        print('messagee: ${apiResponse.message}');
        print('data: ${apiResponse.data}');
        if (apiResponse.code == 200) {
          snackBar = SnackBar(content: Text('Signed up success'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      }
      snackBar = SnackBar(content: Text('Sign up failed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //Navigator.pop(context);
    }

  }

  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        //key: _formKey,
        //autovalidate: true,
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Sign Up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: 'SU Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordController,
              /*validator: (value) {
                if (value == null || value.length < 2 || value.length > 16) {
                  return "Invalid password";
                }
              },*/
              decoration: InputDecoration(labelText: 'Password', helperText: 'Must have numbers, upper and lower case letters. Length: 2-16'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passcodeController,
              decoration: InputDecoration(labelText: 'Passcode'),
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Row(
            children: <Widget> [
              Expanded(child: TextButton(
                style:  ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                          return states.contains(MaterialState.disabled)
                              ? null : Colors.blue;
                        }),
                    backgroundColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) =>
                        states.contains(MaterialState.disabled)
                            ? null : Colors.yellow)),
                  onPressed: _emailController.text.isNotEmpty ? _requestPasscode : null,
                  child: Text("Send Passcode"))
              ),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
              Expanded(child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? null : Colors.blue;
                          }),
                      backgroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) =>
                          states.contains(MaterialState.disabled)
                              ? null
                              : Colors.deepOrangeAccent)),
                  onPressed: formProgress == 1 ? _signUp : null,
                  child: Text("Sign Up"))
              ),
            ],
          ),

        ]));
  }
}
