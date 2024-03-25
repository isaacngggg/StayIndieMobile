import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';

import 'package:stay_indie/screens/HomeScreen.dart';
import 'package:stay_indie/screens/AddScreen.dart';
import 'package:stay_indie/screens/SearchScreen.dart';
import 'package:stay_indie/screens/ProfileScreen.dart';
import 'package:stay_indie/screens/InboxScreen.dart';

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
          Navigator.pushNamed(context, HomeScreen.id);
        } else if (index == 1) {
          Navigator.pushNamed(context, SearchScreen.id);
        } else if (index == 2) {
          Navigator.pushNamed(context, AddScreen.id);
        } else if (index == 3) {
          Navigator.pushNamed(context, InboxScreen.id);
        } else if (index == 4) {
          Navigator.pushNamed(context, ProfileScreen.id);
        }
      },
    );
  }
}
