import 'package:flutter/material.dart';

import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/SocialMetric.dart';

import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/Project.dart';

import 'package:stay_indie/screens/profile/cover_page.dart';
import 'package:stay_indie/screens/profile/content_page.dart';
import 'package:stay_indie/models/connections/Spotify/Track.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'new_profile_page';
  final String profileId;
  final bool selfProfile;
  ProfilePage({required this.profileId, this.selfProfile = false});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double _appBarOpacity = 0.0;
  late bool _showAppBar;
  late PageController _pageController;
  late final Stream<List<Project>> _projectStream;
  late Future<Profile> userProfile;

  List userProjects = [];
  Track? topTrack;
  @override
  void initState() {
    var profileId = widget.profileId;
    _projectStream = supabase
        .from('projects')
        .stream(primaryKey: ['id'])
        .eq('profile_id', profileId)
        // .order('created_at')
        .map((maps) {
          return maps.map((map) => Project.fromMap(map)).toList();
        });

    userProfile = Profile.getProfileData(profileId);

    Project.getProfileProjects(profileId).then((value) {
      setState(() {
        userProjects = value;
      });
    });

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
                  ProfileCoverPage(
                      profileUrl: profileUrl,
                      userProfile: profileSnapshot.data!),
                  StreamBuilder<List<Project>>(
                    stream: _projectStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var projects = snapshot.data!;
                        return ContentPage(
                          userProfile: profileSnapshot.data!,
                          appBarOpacity: _appBarOpacity,
                          pageController: _pageController,
                          profileUrl: profileUrl,
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
