import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/cupertino.dart';

import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/screens/loginSignUpFlow/LoginScreen.dart';

class SettingPage extends StatelessWidget {
  static const id = 'settingpage';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      body: Expanded(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text('General'),
              children: [
                CupertinoListTile(
                  title: Text('Language'),
                  trailing: Text('English'),
                ),
                CupertinoListTile(
                  title: Text('Theme'),
                  trailing: Text('Light'),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: Text('Account'),
              children: [
                CupertinoListTile(
                  title: Text('Edit Profile'),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ProfileEditPage(),
                      ),
                    );
                  },
                ),
                CupertinoListTile(
                  title: Text('Sign Out'),
                  onTap: () {
                    supabase.auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.id, (route) => false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
