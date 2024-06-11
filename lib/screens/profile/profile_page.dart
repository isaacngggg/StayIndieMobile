import 'dart:async';
import 'dart:math';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'dart:ui';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/chat_info.dart';
import 'package:stay_indie/models/ProfileProvider.dart';
import 'package:stay_indie/models/connections/spotify/spotify_signin_helper.dart';

import 'package:stay_indie/screens/chat/chat_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/project/project_page.dart';
import 'package:stay_indie/utilities/LinePainter.dart';
import 'package:stay_indie/widgets/profile/intro_video.dart';
import 'package:stay_indie/widgets/social/SocialMetricList.dart';
import 'package:stay_indie/models/connections/spotify/Track.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:stay_indie/widgets/profile/CoverButton.dart';
import 'package:stay_indie/screens/profile/pages_button.dart';
import 'package:stay_indie/widgets/journeys/my_journey_widget.dart';

//youtube player

// import for topbar
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/widgets/avatars/CircleAvatarWBorder.dart';
import 'package:stay_indie/widgets/navigation/new_nav_bar.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const String id = '/profile';
  final String profileId;
  final bool isProfilePage;
  var key = UniqueKey();
  ProfilePage({required this.profileId, this.isProfilePage = false})
      : super(key: UniqueKey());

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late Future<Profile> userProfile;
  late ScrollController _refresherController;
  late DraggableScrollableController _draggableScrollableController;
  late AnimationController _animationController;

  late ValueNotifier<double> _opacityNotifier;
  late ValueNotifier<double> _sizeNotifier;

  late double topBarHeight;

  Track? topTrack;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Key _journeyWidgetKey = UniqueKey();

  late double _initialChildSize;
  // double _minChildSize = 0.15;
  double _maxChildSize = 0.85;

  void _onRefresh() async {
    await Profile.removeProfileFromPrefs();
    setState(() {
      userProfile = Profile.getProfileData(widget.profileId);
      //UI work
      setState(() {});
    });
  }

  @override
  void initState() {
    _refresherController = ScrollController();
    _draggableScrollableController = DraggableScrollableController();
    _initialChildSize = widget.isProfilePage ? 0.13 : 0.20;

    userProfile = Profile.getProfileData(widget.profileId);
    // if (widget.isProfilePage) {
    //   _draggableScrollableController.animateTo(1,
    //       duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    // }
    _refresherController.addListener(() {
      if (_refresherController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          _refresherController.position.pixels < 0) {
        // If the user is trying to scroll upwards, set the scroll position to 0
        _refresherController.jumpTo(0);
      }
    });

    _draggableScrollableController.addListener(() {
      double currentSize = _draggableScrollableController.size;
      double targetOpacity = (currentSize - _initialChildSize) /
          (_maxChildSize - _initialChildSize);
      print("Target opa" + targetOpacity.toString());
      targetOpacity =
          targetOpacity.clamp(0.0, 1.0); // Ensure opacity stays between 0 and 1
      _sizeNotifier.value = currentSize;
      _opacityNotifier.value = targetOpacity;
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sizeNotifier = ValueNotifier<double>(_animationController.value);
    _opacityNotifier = ValueNotifier<double>(_animationController.value);
    _opacityNotifier.value = 1;

    super.initState();
  }

  void _scrollListener() {
    if (_refresherController.position.pixels >
        _refresherController.position.maxScrollExtent) {
      _refresherController
          .jumpTo(_refresherController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _refresherController.dispose();
    _draggableScrollableController.dispose();
    _animationController.dispose();
    _opacityNotifier.dispose();

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
            return Scaffold(
              body: Stack(
                children: [
                  SmartRefresher(
                    scrollController: _refresherController,
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: _onRefresh,
                    physics: ClampingScrollPhysics(),
                    child: Stack(
                      // Main Stack of build Content
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kTransparent,
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
                        profile.ytShortUrl != null && !kIsWeb
                            ? Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: IntroVideo(
                                  videoUrl: profile.ytShortUrl!,
                                ),
                              )
                            : Container(),
                        const GradientShadowOverlay(),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height *
                                  _initialChildSize),
                          clipBehavior: Clip.none,
                          padding:
                              EdgeInsets.only(left: 16, right: 10, bottom: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    if (profile.name.length > 20)
                                      Text(
                                        profile.name.substring(0, 20) + '...',
                                        style: kHeading2.copyWith(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                          color: kPrimaryColour30,
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (profile.name.length > 20)
                                          Text(
                                            profile.name.substring(
                                                20, profile.name.length),
                                            style: kHeading2.copyWith(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w900,
                                              color: kPrimaryColour30,
                                            ),
                                          )
                                        else
                                          Text(
                                            profile.name,
                                            style: kHeading2.copyWith(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w900,
                                              color: kPrimaryColour30,
                                            ),
                                          ),
                                        SizedBox(width: 10),
                                        _isCurrentUser
                                            ? TextButton(
                                                onPressed: () {
                                                  context
                                                      .push('/myprofile/edit');
                                                },
                                                style: ButtonStyle(
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          Size(0, 0)),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          kTransparent),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          kPrimaryColour40),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: kPrimaryColour40,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Edit Profile',
                                                ),
                                              )
                                            : coverButton, // Add this
                                        // Spacer(),
                                      ],
                                    ),
                                    profile.headline != null
                                        ? Text(
                                            profile.headline!,
                                            style: kHeading4.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: kPrimaryColour30,
                                            ),
                                          )
                                        : Container(),
                                    profile.bio != null
                                        ? ExpandableText(
                                            profile.bio!,
                                            expandText: 'show more',
                                            collapseText: 'show less',
                                            maxLines: 1,
                                            linkColor: kPrimaryColour50,
                                            linkStyle: kBody1.copyWith(
                                                color: kPrimaryColour50,
                                                fontWeight: FontWeight.bold),
                                            style: kBody1,
                                            expandOnTextTap: true,
                                            collapseOnTextTap: true,
                                          )
                                        : Container(),
                                    SizedBox(height: 10),
                                    SocialMetricList(
                                      userId: profile.id,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Expanded(
                                    //       child: SocialMetricList(
                                    //         userId: profile.id,
                                    //       ),
                                    //       // child: _isCurrentUser
                                    //       //     ? TextButton(
                                    //       //         onPressed: () {
                                    //       //           context.push('/myprofile/edit');
                                    //       //         },
                                    //       //         style: kSmallSecondaryButtonStyle,
                                    //       //         child: Text(
                                    //       //           'Edit Profile',
                                    //       //         ),
                                    //       //       )
                                    //       //     : coverButton,
                                    //     ), // Add this
                                    //     SizedBox(width: 10),
                                    //     _isCurrentUser
                                    //         ? Container()
                                    //         : IconButton(
                                    //             icon: FaIcon(
                                    //                 FontAwesomeIcons.paperPlane),
                                    //             onPressed: () {
                                    //               ChatInfo.dmBehaviour(
                                    //                       [profile.id, currentUserId])
                                    //                   .then((value) {
                                    //                 if (value != null) {
                                    //                   Navigator.push(context,
                                    //                       MaterialPageRoute(
                                    //                           builder: (context) {
                                    //                     return ChatPage(
                                    //                       chatId: value.id,
                                    //                     );
                                    //                   }));
                                    //                 }
                                    //               });
                                    //             }),
                                    //     SizedBox(width: 10),
                                    //     IconButton(
                                    //         icon: FaIcon(
                                    //             FontAwesomeIcons.arrowUpFromBracket),
                                    //         onPressed: () {
                                    //           Share.share(
                                    //               'Check out ${profile.name} on Greenroom! https://web.thegreenroom.app/profile/${profile.id}');
                                    //         }),
                                    //   ],
                                    // ),

                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Spacer(),
                                  SizedBox(width: 10),
                                  _isCurrentUser
                                      ? Container()
                                      : IconButton(
                                          icon: FaIcon(
                                              FontAwesomeIcons.paperPlane),
                                          onPressed: () {
                                            ChatInfo.dmBehaviour(
                                                    [profile.id, currentUserId])
                                                .then((value) {
                                              if (value != null) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ChatPage(
                                                    chatId: value.id,
                                                  );
                                                }));
                                              }
                                            });
                                          }),
                                  IconButton(
                                      icon: FaIcon(
                                          FontAwesomeIcons.arrowUpFromBracket),
                                      onPressed: () {
                                        Share.share(
                                            'Check out ${profile.name} on Greenroom! https://web.thegreenroom.app/profile/${profile.id}');
                                      }),
                                  SizedBox(height: 10),
                                  CircleAvatarWBorder(
                                    imageUrl: profile.profileImageUrl,
                                    radius: 16,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   child: GestureDetector(
                        //     onTap: () {

                        //     },
                        //     child: Container(
                        //       height: MediaQuery.of(context).size.height * 0.55,
                        //       width: MediaQuery.of(context).size.width,
                        //       color: kTransparent,
                        //     ),
                        //   ),
                        // ),
                        ValueListenableBuilder<double>(
                          valueListenable: _sizeNotifier,
                          builder: (context, size, _) {
                            print('Size: $size');
                            return Container();
                          },
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: _opacityNotifier,
                          builder: (context, opacity, _) {
                            return TopBar(
                              isProfilePage: widget.isProfilePage,
                              userProfile: profile,
                              opacity: opacity,
                              coverButton: coverButton,
                              ontap: () {
                                _draggableScrollableController.animateTo(
                                    _initialChildSize,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut);
                              },
                            );
                          },
                        ),
                        DraggableScrollableSheet(
                          // controller: _draggableScrollableController,
                          snap: true,
                          initialChildSize: _initialChildSize,
                          minChildSize: _initialChildSize,
                          maxChildSize: _maxChildSize,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            scrollController.addListener(() {
                              double newOpacity = 1.0 -
                                  scrollController.position.pixels /
                                      (scrollController
                                              .position.maxScrollExtent /
                                          2);
                              _opacityNotifier.value =
                                  newOpacity.clamp(0.0, 1.0);
                            });

                            return Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: kTransparent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            kBackgroundColour.withOpacity(
                                                1), // change it to 0.9 to see the effect again
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
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            width: 2,
                                          ),
                                        )),
                                    child: CustomScrollView(
                                        controller: scrollController,
                                        slivers: [
                                          SliverPersistentHeader(
                                            delegate: _SliverAppBarDelegate(
                                              minHeight: 100.0,
                                              maxHeight: 100.0,
                                              child: Container(
                                                // Main Container for the content

                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  color: kTransparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 15, sigmaY: 15),
                                                  child: Container(
                                                    color: kBackgroundColour
                                                        .withOpacity(0.9),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
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
                                                        PagePills(
                                                          userId: profile.id,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            pinned: true,
                                          ),
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 16,
                                                  left: 16,
                                                  bottom: 150),
                                              child: Column(
                                                children: [
                                                  MyJourneyWidget(
                                                      key: _journeyWidgetKey,
                                                      profileId: profile.id),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ])),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}

class PagePills extends StatelessWidget {
  final String userId;
  const PagePills({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool _isCurrentUser = userId == currentUserId;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
      height: 90,
      child: ListView(
        clipBehavior: Clip.none,
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        children: [
          PagesButton(
            title: 'Projects',
            icon: FontAwesomeIcons.recordVinyl,
            pageId: ProjectsPage.id,
            onPressed: () {
              if (_isCurrentUser) {
                context.push(ProjectsPage.id);
              } else {
                context.push('/profile/$userId/projects');
              }
            },
          ),
          // PagesButton(
          //   title:
          //       'Discography',
          //   icon: FontAwesomeIcons
          //       .recordVinyl,
          //   pageId:
          //       'discography',
          // ),
          PagesButton(
            title: 'Socials',
            icon: FontAwesomeIcons.circleNodes,
            pageId: 'socials',
            onPressed: () {
              if (_isCurrentUser) {
                // context.push(SocialsPage.id);
              } else {
                context.push('/profile/$userId/socials');
              }
            },
          ),
          PagesButton(
            title: 'EPK',
            icon: FontAwesomeIcons.file,
            pageId: 'epk_page',
            onPressed: () {
              if (_isCurrentUser) {
                // context.push(EpkPage.id);
              } else {
                context.push('/profile/$userId/epk');
              }
            },
          ),
        ],
      ),
    );
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
          begin: Alignment.topCenter, // Start at the very top
          end: Alignment.bottomCenter,
          stops: [0.0, 0.3, 0.7, 1.0],
          colors: [
            kBackgroundColour.withOpacity(0),
            kBackgroundColour.withOpacity(0),
            kBackgroundColour.withOpacity(0.8),
            kBackgroundColour.withOpacity(1.0),
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
    required this.opacity,
    required this.coverButton,
    required this.isProfilePage,
    required this.ontap,
  });

  final Profile userProfile;
  final double opacity;
  final CoverButton coverButton;
  final bool isProfilePage;
  final Function ontap;

  double topBarHeight = 130;

  @override
  Widget build(BuildContext context) {
    topBarHeight = MediaQuery.of(context).size.height;
    bool _isCurrentUser = userProfile.id == currentUserId;
    return GestureDetector(
      onTap: ontap as void Function()?,
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
                    child: Text(userProfile.name,
                        style: kHeading2.copyWith(
                            fontFamily: GoogleFonts.ebGaramond().fontFamily)),
                  ),
                ),
                Spacer(),
                _isCurrentUser
                    ? IconButton(
                        onPressed: () {
                          context.push(SettingPage.id);
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
