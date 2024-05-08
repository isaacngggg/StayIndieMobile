import 'package:flutter/material.dart';
import 'package:stay_indie/screens/archive/HomeScreen.dart';
import 'package:stay_indie/screens/chat/ChatScreen.dart';
import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/screens/archive/LoginScreen.dart';
import 'package:stay_indie/screens/archive/SignUpScreen.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/loginSignUpFlow/testLoginPage.dart';

/// Page to redirect users to the appropriate page depending on the initial auth state
class SplashScreen extends StatefulWidget {
  static const id = 'splashscreen';
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.id, (route) => false);
    } else {
      clearAllCache(context);
      await Profile.getProfileData(currentUserId).then((profile) {
        if (profile != null) {
          currentUserProfile = profile;
        }
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(InboxScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return preloader;
  }
}
