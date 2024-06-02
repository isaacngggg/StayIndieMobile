import 'package:flutter/material.dart';
import 'package:stay_indie/screens/archive/HomeScreen.dart';
import 'package:stay_indie/screens/chat/chat_page.dart';
import 'package:stay_indie/screens/chat/inbox_page.dart';
import 'package:stay_indie/screens/archive/LoginScreen.dart';
import 'package:stay_indie/screens/archive/SignUpScreen.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/router.dart';
import 'package:go_router/go_router.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/loginSignUpFlow/login_page.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:stay_indie/test_page.dart';

/// Page to redirect users to the appropriate page depending on the initial auth state
class SplashScreen extends StatefulWidget {
  static const id = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if (session == null) {
      context.go(LoginPage.id);
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(LoginPage.id, (route) => false);
    } else {
      clearAllCache(context);
      try {
        await Profile.getProfileData(currentUserId).then((profile) {
          currentUserProfile = profile;
        });
        bool isProfileSetUp = await Profile.checkIfProfileIsSetUp();
        if (isProfileSetUp) {
          context.go(InboxPage.id);

          return;
        } else {
          context.go(InboxPage.id);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StepperForm(
                title: 'Profile Set Up',
                pages: SingleFormPage.profileSetUp,
                onSubmit: (formValues) async {
                  formValues['id'] = supabase.auth.currentUser!.id;
                  Profile.updateProfile(
                      supabase.auth.currentUser!.id, formValues);

                  context.go(InboxPage.id);
                },
              ),
            ),
          );
        }
      } catch (e) {
        print('Error in SplashScreen.dart');

        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/Greenroom.png',
                  width: 100,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                context.go(TestPage.id);
              },
              child: const Text('Test Page'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Greenroom',
              style: kHeading4.copyWith(color: kPrimaryColour),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
