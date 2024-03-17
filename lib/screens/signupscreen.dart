import 'package:flutter/material.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'loginscreen.dart';
import 'package:stay_indie/fields/PrimaryTextField.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = 'signupscreen'; // Add page id here
  String? userEmail;
  String? userPassword;

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
              text: "Sign Up",
              onPressed: () {
                print("Sign Up");
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
