import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/SocialMetric.dart';

import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/Project.dart';

import 'package:stay_indie/screens/archive/cover_page.dart';
import 'package:stay_indie/screens/archive/content_page.dart';
import 'package:stay_indie/models/connections/spotify/Track.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MainProfilePage extends StatefulWidget {
  static const String id = 'main_profile_page';
  final String profileId;
  final bool selfProfile;
  var key = UniqueKey();
  MainProfilePage({required this.profileId, this.selfProfile = false})
      : super(key: UniqueKey());

  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  double _appBarOpacity = 0.0;
  late bool _showAppBar;
  late PageController _pageController;
  late Future<Profile> userProfile;

  late Future<List<Project>> userProjects;
  Track? topTrack;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      var profileId = widget.profileId;

      userProfile = Profile.fetchProfileFromDatabase(profileId);
      userProjects = Project.getProfileProjects(profileId);

      //UI work
      _showAppBar = false;
      _pageController = PageController(initialPage: 0);
      _pageController.addListener(() {
        setState(() {
          if (_pageController.page! > 0.6)
            _appBarOpacity = 5 * _pageController.page! - 4;
          if (_appBarOpacity < 0) _appBarOpacity = 0;
          if (_appBarOpacity > 1) _appBarOpacity = 1;
          if (_pageController.page! > 0.5) {
            _showAppBar = true;
          } else {
            _showAppBar = false;
          }
        });
      });
      _appBarOpacity = 0;
    });
  }

  void _onLoading() async {
    // monitor network fetch
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    var profileId = widget.profileId;

    userProfile = Profile.getProfileData(profileId);
    userProjects = Project.getProfileProjects(profileId);

    //UI work
    _showAppBar = widget.selfProfile;
    _pageController = PageController(initialPage: widget.selfProfile ? 1 : 0);
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page! > 0.6)
          _appBarOpacity = 5 * _pageController.page! - 4;
        if (_appBarOpacity < 0) _appBarOpacity = 0;
        if (_appBarOpacity > 1) _appBarOpacity = 1;
        if (_pageController.page! > 0.5) {
          _showAppBar = true;
        } else {
          _showAppBar = false;
        }
      });
    });
    _appBarOpacity = widget.selfProfile ? 1 : 0;
    super.initState();
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
            var profileUrl = supabase.storage
                .from('profile_images')
                .getPublicUrl(profileSnapshot.data!.id + '.png');
            return Scaffold(
              bottomNavigationBar: widget.selfProfile && _showAppBar
                  ? Opacity(
                      opacity: _appBarOpacity,
                      child: BottomNavBar(pageIndex: 2))
                  : null,
              body: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                clipBehavior: Clip.antiAlias,
                children: [
                  SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ProfileCoverPage(
                        profileUrl: profileUrl,
                        userProfile: profileSnapshot.data!),
                  ),
                  FutureBuilder<List<Project>>(
                    future: userProjects,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var projects = snapshot.data!;
                        return ContentPage(
                          userProfile: profileSnapshot.data!,
                          appBarOpacity: _appBarOpacity,
                          pageController: _pageController,
                          widget: widget,
                          userProjects: projects,
                          topTrack: topTrack,
                        );
                      } else {
                        return preloader;
                      }
                    },
                  ),
                ],
              ),
            );
          }
        });
  }
}
