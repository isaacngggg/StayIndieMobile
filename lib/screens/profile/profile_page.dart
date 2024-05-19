import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/ChatInfo.dart';

import 'package:stay_indie/screens/chat/ChatScreen.dart';

import 'package:stay_indie/screens/profile/edit_basic_info_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/widgets/social/SocialMetricList.dart';
import 'package:stay_indie/models/connections/Spotify/Track.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stay_indie/widgets/profile/CoverButton.dart';
import 'package:stay_indie/screens/profile/pages_button.dart';
import 'package:stay_indie/widgets/journeys/my_journey_widget.dart';

// import for topbar
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'new_profile_page';
  final String profileId;
  final bool isProfilePage;
  var key = UniqueKey();
  ProfilePage({required this.profileId, this.isProfilePage = false})
      : super(key: UniqueKey());

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late Future<Profile> userProfile;
  late ScrollController _scrollController;
  bool _mainPage = false;

  late AnimationController _controller;
  // late Animation<Offset> _animation;
  final double height = 120;
  // final double containerHeight = window.physicalSize.height * 0.9;

  late double topBarHeight;
  Color _backgroundColor = Colors.transparent;
  double _opacity = 1.0;

  Track? topTrack;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Key _journeyWidgetKey = UniqueKey();
  late Animation<double> _opacityAnimation;
  double _initialDragPosition = 0.0;

  void _onRefresh() async {
    setState(() {
      userProfile = Profile.fetchProfileFromDatabase(widget.profileId);

      //UI work
      setState(() {});
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.value >= 0.5) {
        setState(() {
          _mainPage = true;
        });
      } else {
        setState(() {
          _mainPage = false;
        });
      }
    });
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _opacity = _opacityAnimation.value;
        });
      });

    _scrollController = ScrollController();
    // _scrollController.addListener(() {
    //   _controller.value =
    //       _scrollController.offset / _scrollController.position.maxScrollExtent;
    // });
    _scrollController.addListener(_scrollListener);

    userProfile = Profile.getProfileData(widget.profileId);

    if (widget.isProfilePage) {
      _controller.forward();
    }

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _controller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future: userProfile,
        builder: (context, AsyncSnapshot<Profile> profileSnapshot) {
          if (profileSnapshot.connectionState == ConnectionState.waiting) {
            return preloader; // or your custom loader
          } else if (profileSnapshot.hasError) {
            return Text('Error: ${profileSnapshot.error}');
          } else {
            Profile profile = profileSnapshot.data!;
            bool _isCurrentUser = profile.id == currentUserId;
            var coverButton = CoverButton(userProfile: profile);
            var topBarInstance = TopBar(
              isProfilePage: widget.isProfilePage,
              userProfile: profile,
              animationController: _controller,
              opacity: _opacity,
              coverButton: coverButton,
            );

            ;
            return Scaffold(
              body: Stack(
                children: [
                  SmartRefresher(
                    scrollController: _scrollController,
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: _onRefresh,
                    child: Stack(
                      // Main Stack of build Content
                      children: [
                        AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: _controller.duration!,
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            image: DecorationImage(
                              image: NetworkImage(profile.profileImageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                        ),
                        GradientShadowOverlay(),
                        Container(
                          margin: EdgeInsets.only(bottom: height),
                          clipBehavior: Clip.none,
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(profile.name,
                                  style: TextStyle(
                                    fontSize: 43,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColour,
                                  )),
                              profile.headline != null
                                  ? Text(
                                      profile.headline!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColour,
                                      ),
                                    )
                                  : Container(),
                              profile.bio != null
                                  ? Text(
                                      profile.bio!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: kPrimaryColour,
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 20),
                              profile.socialMetrics != null
                                  ? SocialMetricList(
                                      socialMetrics: profile.socialMetrics!,
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: _isCurrentUser
                                          ? TextButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return EditBasicInfoPage();
                                                }));
                                              },
                                              style: kSmallSecondaryButtonStyle,
                                              child: Text(
                                                'Edit Profile',
                                              ),
                                            )
                                          : coverButton), // Add this
                                  SizedBox(width: 10),
                                  IconButton(
                                      icon: FaIcon(FontAwesomeIcons.paperPlane),
                                      onPressed: () {
                                        print('Chat button pressed');
                                        ChatInfo.dmBehaviour(
                                                [profile.id, currentUserId])
                                            .then((value) {
                                          if (value != null) {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ChatScreen(
                                                chatInfo: value,
                                              );
                                            }));
                                          }
                                        });
                                      }),
                                  SizedBox(width: 10),
                                  IconButton(
                                      icon: FaIcon(
                                          FontAwesomeIcons.arrowUpFromBracket),
                                      onPressed: () {}),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        topBarInstance,
                        Positioned(
                            top: (MediaQuery.of(context).size.height - height),
                            left: 0,
                            right: 0,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset.zero,
                                end: Offset(
                                    0.0,
                                    -(MediaQuery.of(context).size.height -
                                            height -
                                            topBarInstance.topBarHeight) /
                                        (MediaQuery.of(context).size.height -
                                            topBarInstance
                                                .topBarHeight)), // Change this to your desired offset
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves
                                      .easeOut, // or Curves.bounceIn for a different effect
                                ),
                              ),
                              child: Opacity(
                                opacity: (1 - _opacity) * 0.3 + 0.7,
                                child: GestureDetector(
                                  onVerticalDragUpdate: (details) {
                                    double dragPercentage = 1 -
                                        (details.globalPosition.dy /
                                            MediaQuery.of(context).size.height);
                                    print(dragPercentage);

                                    _controller.value =
                                        dragPercentage.clamp(0.0, 1.0);
                                    print(_controller.value);
                                  },
                                  onVerticalDragEnd: (details) {
                                    print(_controller.value);
                                    if (_controller.value > 0.5) {
                                      _controller.animateTo(1.0,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeOut);
                                    } else {
                                      _controller.animateTo(0.0,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeOut);
                                    }
                                  },
                                  child: Container(
                                    // Main Container for the content

                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: kTransparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 15, sigmaY: 15),
                                      child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0x60000000),
                                                  kBackgroundColour
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.center,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  width: 2,
                                                ),
                                              )),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              topBarInstance
                                                  .topBarHeight, // Adjust height
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: CustomPaint(
                                                  painter:
                                                      LinePainterHoriztonal(
                                                          width: 20,
                                                          colour:
                                                              kPrimaryColour60),
                                                ),
                                              ),
                                              // Page Pills
                                              GestureDetector(
                                                onVerticalDragStart: (details) {
                                                  _initialDragPosition = details
                                                      .globalPosition
                                                      .dy; // Store initial position
                                                },
                                                onVerticalDragUpdate:
                                                    (details) {
                                                  double dragPercentage = ((details
                                                              .globalPosition
                                                              .dy -
                                                          _initialDragPosition) /
                                                      (MediaQuery.of(context)
                                                          .size
                                                          .height));

                                                  print((details
                                                          .globalPosition.dy -
                                                      _initialDragPosition));
                                                  print(
                                                      'Top: ${(details.globalPosition.dy - _initialDragPosition)}');
                                                  print(
                                                      'bottom: ${MediaQuery.of(context).size.height}');

                                                  print(
                                                      'Drag %: ${dragPercentage}');
                                                  _controller.value = 1 -
                                                      dragPercentage.clamp(
                                                          0.0, 1);
                                                  print(
                                                      'Controller Value: ${_controller.value}');
                                                },
                                                onVerticalDragEnd: (details) {
                                                  // print(_controller.value);
                                                  if (_controller.value > 0.5 ||
                                                      details.primaryVelocity! <
                                                          0) {
                                                    _controller.animateTo(
                                                        1.0); // Animate to fully open if past halfway or flinging up
                                                  } else {
                                                    _controller.animateTo(
                                                        0.0); // Animate to close otherwise
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      top: 20,
                                                      bottom: 10),
                                                  height: 90,
                                                  child: ListView(
                                                    clipBehavior: Clip.none,
                                                    padding: EdgeInsets.all(0),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      PagesButton(
                                                        title: 'Projects',
                                                        icon: FontAwesomeIcons
                                                            .recordVinyl,
                                                        pageId: 'projects',
                                                      ),
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
                                                        icon: FontAwesomeIcons
                                                            .file,
                                                        pageId: 'epk_page',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView(
                                                  physics: _mainPage
                                                      ? AlwaysScrollableScrollPhysics()
                                                      : NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.only(
                                                      right: 16,
                                                      left: 16,
                                                      bottom: 150),
                                                  children: [
                                                    SizedBox(height: 0),
                                                    MyJourneyWidget(
                                                        key: _journeyWidgetKey,
                                                        profileId: profile.id),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  _opacity <= 0.9 && widget.isProfilePage
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Column(
                            children: [
                              AnimatedOpacity(
                                opacity: 1 - _opacity,
                                duration: Duration(
                                    milliseconds: 100), // Adjust duration
                                curve: Curves.easeInOut, // Adjust curve
                                child: NewNavBar(pageIndex: 2),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }
        });
  }
}

class GradientShadowOverlay extends StatelessWidget {
  const GradientShadowOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -0.5),
          end: Alignment.bottomCenter,
          stops: [0.2, 0.8, 1.0],
          colors: [
            kBackgroundColour.withOpacity(0.0),
            kBackgroundColour.withOpacity(0.8),
            kBackgroundColour.withOpacity(1),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  TopBar({
    super.key,
    required this.userProfile,
    required this.animationController,
    required this.opacity,
    required this.coverButton,
    required this.isProfilePage,
  });

  final Profile userProfile;
  final AnimationController animationController;
  final double opacity;
  final CoverButton coverButton;
  final bool isProfilePage;

  double topBarHeight = 130;

  @override
  Widget build(BuildContext context) {
    topBarHeight = MediaQuery.of(context).size.height;
    bool _isCurrentUser = userProfile.id == currentUserId;
    return GestureDetector(
      onTap: () {
        animationController.reverse();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              kTransparent,
              kBackgroundColour.withOpacity(1 - opacity),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10, left: 10, right: 10, bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero(
                //   tag: 'profilePic',
                //   child: CircleAvatarWBorder(
                //       imageUrl: userProfile.profileImageUrl, radius: 18),
                // ),
                // Spacer(),
                isProfilePage
                    ? SizedBox(
                        width: 0,
                      )
                    : IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back)),
                Opacity(
                  opacity: 1 - opacity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(userProfile.name, style: kHeading2),
                  ),
                ),
                Spacer(),
                _isCurrentUser
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SettingPage.id);
                        },
                        icon: Icon(Icons.settings))
                    : opacity == 0
                        ? coverButton
                        : Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}