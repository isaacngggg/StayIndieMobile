import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/buttons/PrimaryButton.dart';
import 'package:stay_indie/screens/LoginScreen.dart';

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: kBackgroundColour,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Settings', style: kHeading2),
          SizedBox(
            height: 10,
          ),
          PrimaryButton(
            text: 'Sign Out',
            onPressed: () async {
              try {
                await supabase.auth.signOut();
                print('Signed out');
              } catch (e) {
                print('Error signing out: $e');
              }
              print('Signed out');
              Navigator.pushReplacementNamed(
                context,
                LoginScreen.id,
              );
            },
          )
        ],
      ),
    );
  }
}
