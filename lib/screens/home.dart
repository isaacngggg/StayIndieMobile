import 'package:flutter/material.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 60,
        elevation: 0,
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: Colors.transparent,
        indicatorShape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            2),
        backgroundColor: kBackgroundColour,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.comments, color: kPrimaryColour30),
            selectedIcon:
                FaIcon(FontAwesomeIcons.solidComments, color: kPrimaryColour),
            label: 'chats',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.addressBook,
              color: kPrimaryColour30,
            ),
            selectedIcon: FaIcon(FontAwesomeIcons.solidAddressBook,
                color: kPrimaryColour),
            label: 'connections',
          ),
          NavigationDestination(
            icon: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 19,
              child: CircleAvatarWBorder(
                  imageUrl: currentUserProfile.profileImageUrl, radius: 16),
            ),
            selectedIcon: CircleAvatar(
              backgroundColor: kPrimaryColour,
              radius: 19,
              child: CircleAvatarWBorder(
                imageUrl: currentUserProfile.profileImageUrl,
                radius: 16,
              ),
            ),
            label: 'profile',
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
