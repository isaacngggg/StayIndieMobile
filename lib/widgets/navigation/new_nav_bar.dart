import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter/material.dart';

import 'package:stay_indie/screens/archive/MainProfilePage.dart';
import 'package:stay_indie/screens/connections_page.dart';

import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';

import 'package:stay_indie/screens/profile/profile_page.dart';

class NewNavBar extends StatelessWidget {
  NewNavBar({
    super.key,
    required this.pageIndex,
    this.opacity = 1,
  });

  final int pageIndex;
  double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: kBackgroundColour.withOpacity(opacity),
      child: SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    NoAnimationRoute(builder: (context) => InboxScreen()));
              },
              icon: FaIcon(
                  pageIndex == 0
                      ? FontAwesomeIcons.solidComments
                      : FontAwesomeIcons.comments,
                  color: kPrimaryColour30),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    NoAnimationRoute(builder: (context) => ContactsPage()));
              },
              icon: FaIcon(
                  pageIndex == 1
                      ? FontAwesomeIcons.solidAddressBook
                      : FontAwesomeIcons.addressBook,
                  color: kPrimaryColour30),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    NoAnimationRoute(
                        builder: (context) => ProfilePage(
                              profileId: currentUserId,
                              isProfilePage: true,
                            )));
              },
              icon: CircleAvatar(
                backgroundColor:
                    pageIndex == 2 ? kPrimaryColour : Colors.transparent,
                radius: 19,
                child: CircleAvatarWBorder(
                    imageUrl: currentUserProfile.profileImageUrl, radius: 16),
              ),
            ),
          ],
        ),
      ),
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
