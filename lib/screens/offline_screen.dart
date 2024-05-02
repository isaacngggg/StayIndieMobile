import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

class OfflineSplashScreen extends StatelessWidget {
  static String id = 'offline_screen';
  const OfflineSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('You are currently Offline'),
    );
  }
}
