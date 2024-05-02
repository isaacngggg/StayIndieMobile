import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';

import 'package:stay_indie/screens/profile/MainProfilePage.dart';
import 'package:stay_indie/screens/connections_page.dart';

import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 1,
      indicatorColor: Colors.transparent,
      indicatorShape: ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          2),
      backgroundColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: pageIndex,
      destinations: [
        NavigationDestination(
          icon: FaIcon(FontAwesomeIcons.comments),
          selectedIcon: FaIcon(FontAwesomeIcons.solidComments),
          label: 'chats',
        ),
        NavigationDestination(
          icon: FaIcon(FontAwesomeIcons.addressBook),
          selectedIcon: FaIcon(FontAwesomeIcons.solidAddressBook),
          label: 'connections',
        ),
        NavigationDestination(
          icon: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 19,
            child: CircleAvatarWBorder(
                imageUrl: currentUserProfile!.profileImageUrl, radius: 16),
          ),
          selectedIcon: CircleAvatar(
            backgroundColor: kAccentColour,
            radius: 19,
            child: CircleAvatarWBorder(
              imageUrl: currentUserProfile!.profileImageUrl,
              radius: 16,
            ),
          ),
          label: 'profile',
        ),
      ],
      onDestinationSelected: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => InboxScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, NoAnimationRoute(builder: (context) => SearchScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context,
              NoAnimationRoute(
                  builder: (context) => ProfilePage(
                        profileId: currentUserId,
                        selfProfile: true,
                      )));
        }
      },
    );
  }
}

class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  NoAnimationRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
