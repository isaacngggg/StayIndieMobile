import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Journey.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/SingleFormPage.dart';
import 'package:stay_indie/screens/profile/pages_button.dart';
import 'package:stay_indie/screens/profile/top_bar.dart';
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/screens/templates/stepper_form.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';

import 'package:stay_indie/widgets/projects/ProjectTile.dart';
import 'package:stay_indie/widgets/journeys/my_journey_widget.dart';

import 'package:stay_indie/models/Project.dart';
import 'package:stay_indie/screens/archive/MainProfilePage.dart';

import 'package:stay_indie/models/connections/spotify/Track.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ContentPage extends StatefulWidget {
  ContentPage({
    super.key,
    required this.userProfile,
    required double appBarOpacity,
    required PageController pageController,
    // required this.profileUrl,
    required this.widget,
    required this.userProjects,
    this.topTrack,
  })  : _appBarOpacity = appBarOpacity,
        _pageController = pageController;

  Profile userProfile;
  final double _appBarOpacity;
  final PageController _pageController;
  // final String profileUrl;
  final MainProfilePage widget;
  final List userProjects;

  final Track? topTrack;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Key journeyWidgetKey = UniqueKey();

  void _onRefresh() async {
    await Profile.getProfileData(widget.userProfile.id).then((value) {
      setState(() {
        journeyWidgetKey = UniqueKey();
      });
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Profile.getProfileData(widget.userProfile.id).then((value) {
      setState(() {
        print('Loading done: User Profile => $value');
        widget.userProfile = value;
      });
    });
    _refreshController.loadComplete();
  }

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
            TopBar(
              userProfile: widget.userProfile,
              appBarOpacity: widget._appBarOpacity,
              pageController: widget._pageController,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        widget.userProfile.profileColor,
                        kBackgroundColour
                      ],
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
                                    child: SmartRefresher(
                                      controller: _refreshController,
                                      enablePullDown: true,
                                      onRefresh: _onRefresh,
                                      onLoading: _onLoading,
                                      child: ListView(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 16),
                                        children: [
                                          SizedBox(height: 35),
                                          if (widget.topTrack != null) ...[
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Image.network(
                                                            widget.topTrack
                                                                    ?.imageUrl
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
                                                              widget.topTrack
                                                                      ?.name ??
                                                                  '',
                                                              style: kHeading4),
                                                          SizedBox(width: 10),
                                                          Text(
                                                              widget.topTrack
                                                                      ?.year ??
                                                                  '',
                                                              style: kBody1),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      FaIcon(FontAwesomeIcons
                                                          .play),
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
                                                      icon:
                                                          FontAwesomeIcons.file,
                                                      pageId: 'epk_page',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          MyJourneyWidget(
                                              key: journeyWidgetKey,
                                              profileId: widget.userProfile.id),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
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
                                                        kSmallPrimaryButtonStyle,
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
                                                                        .defaultPages,
                                                                    mediaBucket:
                                                                        'project_medias',
                                                                    onSubmit:
                                                                        (formValue) {
                                                                      print(
                                                                          formValue);
                                                                      var newProject =
                                                                          Project.fromMap(
                                                                              formValue);
                                                                      Project.addProject(
                                                                          newProject);
                                                                    });
                                                              }));
                                                    }),
                                                for (var project
                                                    in widget.userProjects) ...[
                                                  SizedBox(height: 10),
                                                  ProjectTile(
                                                    project: project,
                                                    profile: widget.userProfile,
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
