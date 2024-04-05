import 'package:flutter/material.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/archive/HomeScreen.dart';
import 'LoginScreen.dart';
import 'package:stay_indie/fields/PrimaryTextField.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'dart:async';

class SignUpScreen extends StatelessWidget {
  static const String id = 'signupscreen'; // Add page id here
  String? userEmail;
  String? userPassword;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
              controller: emailController,
              labelText: 'Email ',
            ),
            SizedBox(height: 16.0),
            PrimaryTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            PrimaryButton(
              text: "Sign Up",
              onPressed: () async {
                final authResponse = await supabase.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(authResponse.user!.email!),
                ));
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              },
              buttonType: PrimaryButtonType.defaultButton,
            ),
            SizedBox(height: 5.0),
            PrimaryButton(
              text: "Login Instead",
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          LoginScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ));
              },
              buttonType: PrimaryButtonType.textButton,
            ),
          ],
        ),
      ),
    );
  }
}
