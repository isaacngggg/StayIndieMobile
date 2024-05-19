import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.userProfile,
    required double appBarOpacity,
    required PageController pageController,
  })  : _appBarOpacity = appBarOpacity,
        _pageController = pageController;

  final Profile userProfile;
  final double _appBarOpacity;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      },
      child: Container(
        color: kBackgroundColour,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Opacity(
              opacity: _appBarOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'profilePic',
                    child: CircleAvatarWBorder(
                        imageUrl: userProfile.profileImageUrl, radius: 18),
                  ),
                  Spacer(),
                  Text(userProfile.name, style: kHeading2),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SettingPage.id);
                      },
                      icon: Icon(Icons.settings)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
