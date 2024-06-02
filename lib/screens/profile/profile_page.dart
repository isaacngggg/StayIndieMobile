import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/youtube/v3.dart';
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
  late AnimationController _controller;

  // late DraggableScrollableController _draggableScrollableController;
  // late Animation<Offset> _animation;
  // final double height = 120;
  // final double containerHeight = window.physicalSize.height * 0.9;

  late double topBarHeight;
  Color _backgroundColor = Colors.transparent;
  double _opacity = 1.0;

  Track? topTrack;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Key _journeyWidgetKey = UniqueKey();
  late Animation<double> _opacityAnimation;

  ValueNotifier<double> _opacityNotifier = ValueNotifier<double>(1.0);

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
    _initialChildSize = widget.isProfilePage ? 0.13 : 0.20;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    // _draggableScrollableController = DraggableScrollableController();
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _opacity = _opacityAnimation.value;
        });
      });

    _refresherController = ScrollController();

    userProfile = Profile.getProfileData(widget.profileId);
    if (widget.isProfilePage) {
      // _draggableScrollableController.animateTo(1,
      //     duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
    _refresherController.addListener(() {
      if (_refresherController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          _refresherController.position.pixels < 0) {
        // If the user is trying to scroll upwards, set the scroll position to 0
        _refresherController.jumpTo(0);
      }
    });

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
    _controller.dispose();
    _opacityNotifier.dispose();

    // _draggableScrollableController.dispose();
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
                              EdgeInsets.only(left: 20, right: 20, bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(profile.name, style: kHeading1),
                              profile.headline != null
                                  ? Text(
                                      profile.headline!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: kPrimaryColour30,
                                      ),
                                    )
                                  : Container(),
                              profile.bio != null
                                  ? ExpandableText(
                                      profile.bio!,
                                      expandText: 'show more',
                                      collapseText: 'show less',
                                      maxLines: 2,
                                      linkColor: kPrimaryColour,
                                      linkStyle: kBody1.copyWith(
                                          color: kPrimaryColour,
                                          fontWeight: FontWeight.bold),
                                      style: kBody1,
                                      expandOnTextTap: true,
                                      collapseOnTextTap: true,
                                    )
                                  : Container(),
                              SizedBox(height: 10),
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
                                                context.push('/myprofile/edit');
                                              },
                                              style: kSmallSecondaryButtonStyle,
                                              child: Text(
                                                'Edit Profile',
                                              ),
                                            )
                                          : coverButton), // Add this
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
                                  SizedBox(width: 10),
                                  IconButton(
                                      icon: FaIcon(
                                          FontAwesomeIcons.arrowUpFromBracket),
                                      onPressed: () {
                                        Share.share(
                                            'Check out ${profile.name} on Greenroom! https://web.thegreenroom.app/profile/${profile.id}');
                                      }),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        topBarInstance,
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
                                                        PagePills(),
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
  const PagePills({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          ),
          PagesButton(
            title: 'EPK',
            icon: FontAwesomeIcons.file,
            pageId: 'epk_page',
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
          begin: Alignment(0, -0.5),
          end: Alignment.bottomCenter,
          colors: [
            kBackgroundColour.withOpacity(0.0),
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
                Hero(
                  tag: 'profilePic',
                  child: CircleAvatarWBorder(
                      imageUrl: userProfile.profileImageUrl, radius: 18),
                ),
                Spacer(),
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
