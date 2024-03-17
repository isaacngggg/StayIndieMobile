import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/fields/PrimaryTextField.dart';
import 'signupscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginscreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? _user;
  // Add page id here
  // String? userEmail;
  // String? userPassword;

  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    setState(() {
      _user = Supabase.instance.client.auth.currentUser;
    });
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _user = data.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  String? userEmail;
  String? userPassword;

  LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'stay indie',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.0),
          PrimaryTextField(
              labelText: 'Email ',
              onChanged: (value) {
                userEmail = value;
                print(value);
              }),
          SizedBox(height: 16.0),
          PrimaryTextField(
              labelText: 'Password',
              obscureText: true,
              onChanged: (value) {
                userEmail = value;
                print(value);
              }),
          SizedBox(height: 16.0),
          PrimaryButton(
            text: "Login",
            onPressed: () => print("login"),
            buttonType: PrimaryButtonType.defaultButton,
          ),
          SizedBox(height: 5.0),
          PrimaryButton(
            text: "Sign Up Instead",
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        SignUpScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ));
            },
            buttonType: PrimaryButtonType.textButton,
          ),
        ],
      ),
    );
  }
}
