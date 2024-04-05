import 'package:flutter/material.dart';

import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/SocialMetric.dart';

import 'package:stay_indie/widgets/navigation/mvp_nav_bar.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/models/Project.dart';

import 'package:stay_indie/screens/profile/cover_page.dart';
import 'package:stay_indie/screens/profile/content_page.dart';

class NewProfilePage extends StatefulWidget {
  static const String id = 'new_profile_page';
  final String profileId;
  final bool selfProfile;
  NewProfilePage({required this.profileId, this.selfProfile = false});

  @override
  _NewProfilePageState createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  double _appBarOpacity = 0.0;
  late bool _showAppBar;
  late PageController _pageController;
  late final Stream<List<Project>> _projectStream;

  Profile userProfile = Profile(
    id: '1',
    username: 'marias',
    name: 'The Marias',
    headline: 'Indie Band in Los Angeles',
    bio:
        'Hi! I am a Product Design who is passionate about entertainment and technology.',
    location: 'Los Angeles',
    createdAt: DateTime.now(),
    profileImagePath: 'assets/marias_profile.png',
    connectionsProfileIds: [],
    socialMetrics: [
      SocialMetric(name: 'facebook', value: '14k', unit: 'followers'),
      SocialMetric(name: 'instagram', value: '14k', unit: 'followers'),
      SocialMetric(name: 'twitter', value: '14k', unit: 'followers'),
      SocialMetric(name: 'facebook', value: '14k', unit: 'followers'),
    ],
  );

  List userProjects = [];
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
    Profile.getProfileData(profileId).then((value) {
      if (value != null) {
        setState(() {
          userProfile = value;
        });
      }
    });
    Project.getProfileProjects(profileId).then((value) {
      setState(() {
        userProjects = value;
      });
    });

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

  @override
  Widget build(BuildContext context) {
    var profileUrl = supabase.storage
        .from('profile_images')
        .getPublicUrl(userProfile.id + '.png');
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.selfProfile && _showAppBar
          ? Opacity(opacity: _appBarOpacity, child: BottomNavBar(pageIndex: 2))
          : null,
      // appBar: _showAppBar
      //     ? AppBar(
      //         title: _showAppBar
      //             ? Text(
      //                 userProfile.name,
      //                 style: TextStyle(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.white),
      //               )
      //             : null,
      //         centerTitle: false,
      //         backgroundColor: _showAppBar ? Colors.black : Colors.transparent,
      //         actions: [
      //           Padding(
      //             padding: EdgeInsets.symmetric(horizontal: 20),
      //             child: GestureDetector(
      //               onTap: () {
      //                 _pageController.animateToPage(0,
      //                     duration: Duration(milliseconds: 500),
      //                     curve: Curves.easeInOut);
      //               },
      //               child:
      //                   CircleAvatarWBorder(imageUrl: profileUrl, radius: 18),
      //             ),
      //           ),
      //           IconButton(
      //             onPressed: () {
      //               showCupertinoModalBottomSheet(
      //                   expand: false,
      //                   context: context,
      //                   backgroundColor: Colors.transparent,
      //                   builder: (context) => SettingsModal());
      //             },
      //             icon: Icon(Icons.more_vert),
      //             color: Colors.white,
      //           ),
      //           SizedBox(width: 10)
      //         ],
      //       )
      //     : null,
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.antiAlias,
        children: [
          ProfileCoverPage(profileUrl: profileUrl, userProfile: userProfile),
          StreamBuilder<List<Project>>(
            stream: _projectStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var projects = snapshot.data!;
                return ProfileMainPage(
                    userProfile: userProfile,
                    appBarOpacity: _appBarOpacity,
                    pageController: _pageController,
                    profileUrl: profileUrl,
                    widget: widget,
                    userProjects: projects);
              } else {
                return ProfileMainPage(
                    userProfile: userProfile,
                    appBarOpacity: _appBarOpacity,
                    pageController: _pageController,
                    profileUrl: profileUrl,
                    widget: widget,
                    userProjects: userProjects);
              }
            },
          ),
        ],
      ),
    );
  }
}
