import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/loginSignUpFlow/login_page.dart';
import 'package:stay_indie/screens/profile/edit_basic_info_page.dart';
import 'package:stay_indie/screens/socials/connect_social_page.dart';

import 'package:stay_indie/screens/archive/profile_edit_page.dart';
import 'package:stay_indie/screens/archive/LoginScreen.dart';

class SettingPage extends StatelessWidget {
  static const id = 'settingpage';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            backgroundColor: kBackgroundColour,
            header: Text(
              'General',
              style: kHeading4.copyWith(color: kPrimaryColour),
            ),
            children: [
              ListTile(
                title: Text('Language'),
                trailing: Text('English'),
              ),
              ListTile(
                title: Text('Theme'),
                trailing: Text('Light'),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: kBackgroundColour,
            header: Text(
              'Account',
              style: kHeading4.copyWith(color: kPrimaryColour),
            ),
            children: [
              ListTile(
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => EditBasicInfoPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Connect Socials'),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => ConnectSocialPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Clear Cache'),
                onTap: () {
                  clearAllCache(context);
                  // Clear cache
                },
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            backgroundColor: kBackgroundColour,
            header: Text(
              'Danger Zone',
              style: kHeading4.copyWith(color: kPrimaryColour),
            ),
            children: [
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  clearAllCache(context);
                  supabase.auth.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(LoginPage.id, (route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
