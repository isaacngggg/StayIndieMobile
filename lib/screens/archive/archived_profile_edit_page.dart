import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/cupertino.dart';

import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/screens/archive/LoginScreen.dart';
import 'package:stay_indie/screens/socials/connect_social_page.dart';

class ProfileEditPage extends StatelessWidget {
  static const id = 'profile_edit_page';
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: ListView(
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
            header: Text('Edit Basic Info'),
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
                title: Text('Connect Socials'),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => ConnectSocialPage(),
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
    );
  }
}