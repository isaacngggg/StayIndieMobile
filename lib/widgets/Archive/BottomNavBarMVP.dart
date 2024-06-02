import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';

import 'package:stay_indie/screens/archive/HomeScreen.dart';
import 'package:stay_indie/screens/archive/AddScreen.dart';
import 'package:stay_indie/screens/archive/MainProfilePage.dart';
import 'package:stay_indie/screens/contacts_page.dart';

import 'package:stay_indie/screens/chat/inbox_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: pageIndex,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: 'home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'search'),
        NavigationDestination(icon: Icon(Icons.add_circle), label: 'add'),
        NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded), label: 'chat'),
        NavigationDestination(
            icon: Icon(Icons.account_circle), label: 'profile'),
      ],
      onDestinationSelected: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => HomeScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => ContactsPage()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => AddScreen()));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => InboxPage()));
        } else if (index == 4) {
          Navigator.pushReplacement(
              context,
              NoAnimationRoute(
                  builder: (context) => MainProfilePage(
                        profileId: currentUserId,
                        selfProfile: true,
                      )));
        }
      },
    );
  }
}
