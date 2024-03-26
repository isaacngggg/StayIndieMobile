import 'package:flutter/material.dart';
import 'package:stay_indie/screens/HomeScreen.dart';
import 'package:stay_indie/screens/LoginScreen.dart';
import 'package:stay_indie/screens/SignUpScreen.dart';
import 'package:stay_indie/constants.dart';

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
          .pushNamedAndRemoveUntil(LoginScreen.id, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: preloader);
  }
}
