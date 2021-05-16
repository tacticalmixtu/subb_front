import 'package:flutter/material.dart';
import 'package:subb_front/utils/api_collection.dart';
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
  late bool _hidePassword;
  double formProgress = 0;
  //final _formKey = GlobalKey<FormState>();

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
    await requestPasscode(email: _emailController.text);
  }

  void popScreen() {
    Navigator.of(context).pop();
  }

  /*int validate() {
    String out;
    late final SnackBar snackBar;

    if (_emailController.text.length < 6) {
      snackBar = SnackBar(content: Text("Invalid email address"));
      //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
    if (_passwordController.text.length < 2 || _passwordController.text.length > 16) {
      snackBar = SnackBar(content: Text("Invalid password length"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return -1;
    }
    return 0;
  }*/
  //void _placeholder() {}

  void _signUp() async {
    final apiResponse = await signUp(
        email: _emailController.text,
        password: _passwordController.text,
        passcode: _passcodeController.text);

    late final SnackBar snackBar;
    if (apiResponse != null) {
      print('code: ${apiResponse.code}');
      print('messagee: ${apiResponse.message}');
      print('data: ${apiResponse.data}');
      if (apiResponse.code == 200) {
        snackBar = SnackBar(content: Text('Signed up success'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else if (apiResponse.code == 401) {
        snackBar =
            SnackBar(content: Text('SUmail already exists. Please sign in.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else if (apiResponse.code == 402) {
        snackBar = SnackBar(content: Text('Incorrect verification code'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }
    snackBar = SnackBar(content: Text('Sign up failed'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        //key: _formKey,
        //autovalidate: true,
        onChanged: updateFormProgress,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Sign up', style: Theme.of(context).textTheme.headline5),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'SUmail',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF76900))),
                //suffixIcon: Icon(Icons.check_circle),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: TextButton(
                  onPressed: _requestPasscode,
                  child: Text(
                    "   Send verification code",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passcodeController,
              maxLength: 10,
              //textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: 'Enter your code',
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
                labelText: 'Create your password',
                labelStyle: TextStyle(color: Color(0xFFF76900)),
                helperText:
                    'Password should contain numbers, upper case letters and lower case letters. No special characters. Length: 2-16.', // Length: 2-16',
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
                    onPressed: _requestPasscode,
                    child: Text(
                      "", //"""Send verification code",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B72D7)),
                    )),
              ),
              Expanded(child: Padding(padding: EdgeInsets.all(4.0))),
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
                    //onPressed: formProgress == 1 ? _signUp : null, //_placeholder,
                    onPressed: _signUp,
                    child: Text("Sign up")),
              ),
            ],
          ),
        ]));
  }
}
/*
          /* Padding(
            padding: EdgeInsets.all(2.0),
            child:               TextButton(
                onPressed: _requestPasscode,
                child:Text("Send verification code", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),)),
          ),*/
        Row(
            children: <Widget> [
              Expanded(child:
              TextButton(
                  onPressed: _requestPasscode,
                  child:Text("Send verification code", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),)),
              ),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
              Expanded(child: Padding(padding:EdgeInsets.all(2.0))),
          ]
        ),


Row(children: <Widget> [
            Padding(padding: EdgeInsets.all(5.0)),
            TextButton(
                onPressed: _requestPasscode,
                child: Text("Send verification code", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2B72D7)),)),]
          ),*/
/*TextButton(
              onPressed: _requestPasscode,
              child: Text("Send Passcode", style: TextStyle(color: Color(0xFF2B72D7)),)),
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
              onPressed: _signUp,
              child: Text("Sign up")),
          Padding(padding: EdgeInsets.all(8.0)),*/
/*Row(
            children: <Widget> [
              Padding(padding: EdgeInsets.all(8.0)),
              TextButton(
                  onPressed: _requestPasscode,
                  child: Text("Send Passcode", style: TextStyle(color: Color(0xFF2B72D7)),)),

              //(child: Padding(padding:EdgeInsets.all(2.0))),
              Padding(padding: EdgeInsets.all(8.0)),

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
                  onPressed: _signUp,
                  child: Text("Sign Up")),

            ],
          ),*/
