import 'package:flutter/material.dart';
import 'package:subb_front/screens/home/home.dart';
import 'package:subb_front/utils/network.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = '/resetpassword';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBB'),
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
    final apiResponse = await doPost(
      _requestPasscodeApi,
      {
        'email': _emailController.text,
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

  void _reset() async {
    final apiResponse = await doPost(
      _resetPasswordApi,
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
      print('message: ${apiResponse.message}');
      print('data: ${apiResponse.data}');
      snackBar = SnackBar(content: Text('Reset password success'));
    } else {
      snackBar = SnackBar(content: Text('Reset Password failed'));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Reset Password', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            // TODO: use password hidden
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            // TODO: use password hidden
            child: TextFormField(
              controller: _passcodeController,
              decoration: InputDecoration(labelText: 'Passcode'),
            ),
          ),

          //Padding(padding: EdgeInsets.all(8.0)),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextButton(
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
                                      : Colors.yellow)),
                      onPressed: _emailController.text.isNotEmpty
                          ? _requestPasscode
                          : null,
                      child: Text("Request Code"))),
              Expanded(child: Padding(padding: EdgeInsets.all(2.0))),
              Expanded(
                child: TextButton(
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
                    onPressed: _reset,
                    child: Text("Reset Password")),
              ),
            ],
          ),
        ]));
  }
}
