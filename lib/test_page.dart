import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'package:stay_indie/models/connections/google_signin_helper.dart';
import 'package:stay_indie/models/connections/soundcloud_login_helper.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);
  static const String id = '/test_page';

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    // SoundCloudLogin soundCloudLogin = SoundCloudLogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                context.go('/myprofile');
              },
              child: const Text('Navigate to Profile Page'),
            ),
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                context.go('/inbox');
              },
              child: const Text('Navigate to Inbox'),
            ),
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SoundCloudLogin()),
                );
              },
              child: const Text('Connect to Soundcloud'),
            ),
          ],
        ),
      ),
    );
  }
}
