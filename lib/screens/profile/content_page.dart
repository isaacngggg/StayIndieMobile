import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/objects/Profile.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/projects/ProjectTile.dart';
import 'package:stay_indie/widgets/journeys/MyJourneyWidget.dart';
import 'package:stay_indie/screens/profile/edit_basic_info_page.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/screens/profile/NewProfilePage.dart';
import 'package:stay_indie/screens/project/addProjectFlow/add_project_screen.dart';

class ProfileMainPage extends StatelessWidget {
  const ProfileMainPage({
    super.key,
    required this.userProfile,
    required double appBarOpacity,
    required PageController pageController,
    required this.profileUrl,
    required this.widget,
    required this.userProjects,
  })  : _appBarOpacity = appBarOpacity,
        _pageController = pageController;

  final Profile userProfile;
  final double _appBarOpacity;
  final PageController _pageController;
  final String profileUrl;
  final NewProfilePage widget;
  final List userProjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundColour,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.black,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          userProfile.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(_appBarOpacity),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: _appBarOpacity,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child: CircleAvatarWBorder(
                                imageUrl: profileUrl, radius: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    widget.selfProfile
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      kAccentColour10),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Text('Edit Profile'),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfileEditPage();
                                  }));
                                }),
                          )
                        : Container(),
                    DefaultTabController(
                      length: 3,
                      child: Expanded(
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'About'),
                                Tab(text: 'Projects'),
                                Tab(text: 'Activity'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Container(
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      children: [
                                        SizedBox(height: 10),
                                        MyJourneyWidget(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                              child: ListView(
                                                  clipBehavior: Clip.none,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [
                                                SizedBox(height: 10),
                                                TextButton(
                                                    style:
                                                        kSecondaryButtonStyle,
                                                    child: Text('Add Project'),
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          AddProjectPage.id);
                                                    }),
                                                for (var project
                                                    in userProjects) ...[
                                                  SizedBox(height: 10),
                                                  ProjectTile(project: project),
                                                ]
                                              ])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text('No Activities'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
