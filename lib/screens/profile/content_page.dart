import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

import 'package:stay_indie/models/connections/Spotify/Spotify.dart';
import 'package:stay_indie/models/connections/Spotify/Track.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({
    super.key,
    required this.userProfile,
    required double appBarOpacity,
    required PageController pageController,
    required this.profileUrl,
    required this.widget,
    required this.userProjects,
    this.topTrack,
  })  : _appBarOpacity = appBarOpacity,
        _pageController = pageController;

  final Profile userProfile;
  final double _appBarOpacity;
  final PageController _pageController;
  final String profileUrl;
  final ProfilePage widget;
  final List userProjects;

  final Track? topTrack;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundColour,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: kBackgroundColour,
              child: SafeArea(
                bottom: false,
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
                    gradient: RadialGradient(
                      colors: [userProfile.profileColor, kBackgroundColour],
                      center: Alignment.topLeft,
                      radius: 1.2,
                      stops: [0.1, 1.0],
                      transform: GradientRotation(0.5),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            // Activites and Project Tabs can be enabled in the future.

                            // TabBar(
                            //   tabs: [
                            //     Tab(text: 'About'),
                            //     Tab(text: 'Projects'),
                            //     // Tab(text: 'Activity'),
                            //   ],
                            // ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  Container(
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 20),
                                      children: [
                                        SizedBox(height: 35),
                                        if (topTrack != null) ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text('Top Track',
                                                  style: kHeading2),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: kOutlineBorder,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: Image.network(
                                                          topTrack?.imageUrl
                                                                  .toString() ??
                                                              '',
                                                          width: 80,
                                                          height: 80),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            topTrack?.name ??
                                                                '',
                                                            style: kHeading4),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            topTrack?.year ??
                                                                '',
                                                            style: kBody1),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    FaIcon(
                                                        FontAwesomeIcons.play),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                        ],
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text('Pages', style: kHeading2),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              height: 56,
                                              child: ListView(
                                                clipBehavior: Clip.none,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: [
                                                  PagesButton(
                                                    title: 'Discography',
                                                    icon: FontAwesomeIcons
                                                        .recordVinyl,
                                                    pageId: 'discography',
                                                  ),
                                                  PagesButton(
                                                    title: 'Socials',
                                                    icon: FontAwesomeIcons
                                                        .circleNodes,
                                                    pageId: 'socials',
                                                  ),
                                                  PagesButton(
                                                    title: 'EPK',
                                                    icon: FontAwesomeIcons.file,
                                                    pageId: 'epk_page',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        MyJourneyWidget(
                                            profileId: userProfile.id),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: kBackgroundColour,
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
                                                  ProjectTile(
                                                    project: project,
                                                    profile: userProfile,
                                                  ),
                                                ]
                                              ])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Center(
                                  //   child: Text('No Activities'),
                                  // ),
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

class PagesButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String pageId;

  const PagesButton({
    required this.title,
    required this.icon,
    required this.pageId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: kOutlineBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: kHeading4,
              ),
              SizedBox(width: 15),
              FaIcon(
                icon,
                size: 26,
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, pageId),
    );
  }
}
