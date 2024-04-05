import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/navigation/BottomNavBarMVP.dart';
import 'package:stay_indie/widgets/projects/ProjectTile.dart';
import 'package:stay_indie/widgets/journeys/MyJourneyWidget.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/screens/profile/MainProfilePage.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';

import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart' as mvp;

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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.black,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          userProfile.name,
                          style: TextStyle(
                            fontSize: 23,
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
                decoration: BoxDecoration(
                  color: kBackgroundColour,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Center(
                        child: CustomPaint(
                            size: Size(0, 0),
                            painter: LinePainterHoriztonal(width: 30)),
                      ),
                    ),
                    widget.selfProfile
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                                style: kWiredButtonSmall,
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
                                        MyJourneyWidget(
                                            profileId: userProfile.id),
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
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              maintainState:
                                                                  false,
                                                              allowSnapshotting:
                                                                  false,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (context) {
                                                                return StepperForm(
                                                                    title:
                                                                        'Add a Project',
                                                                    pages: SingleFormPage
                                                                        .defaultPages);
                                                              }));
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
