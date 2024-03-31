import 'package:flutter/material.dart';

import 'package:stay_indie/constants.dart';

import 'package:stay_indie/objects/SocialMetric.dart';

import 'package:stay_indie/widgets/navigation/BottomNavBar.dart';

import 'package:stay_indie/objects/Profile.dart';
import 'package:stay_indie/objects/Project.dart';

import 'package:stay_indie/screens/profile/cover_page.dart';
import 'package:stay_indie/screens/profile/content_page.dart';

class NewProfilePage extends StatefulWidget {
  static const String id = 'new_profile_page';
  final bool selfProfile;
  NewProfilePage({this.selfProfile = false});

  @override
  _NewProfilePageState createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  double _appBarOpacity = 0.0;
  late bool _showAppBar;
  late PageController _pageController;

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
    Profile.getProfileData().then((value) {
      if (value != null) {
        setState(() {
          userProfile = value;
        });
      }
    });
    Project.getCurrentUserProjects().then((value) {
      setState(() {
        userProjects = value;
        print(userProjects);
      });
    });

    _showAppBar = widget.selfProfile;
    _pageController = PageController(initialPage: widget.selfProfile ? 1 : 0);
    _pageController.addListener(() {
      setState(() {
        _appBarOpacity = _pageController.page!;
        if (_appBarOpacity < 0) _appBarOpacity = 0;
        if (_appBarOpacity > 1) _appBarOpacity = 1;
        if (_pageController.page! > 0.90) {
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
      backgroundColor: Colors.deepPurple.shade500,
      bottomNavigationBar:
          widget.selfProfile ? BottomNavBar(pageIndex: 4) : null,
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
          ProfileMainPage(
              userProfile: userProfile,
              appBarOpacity: _appBarOpacity,
              pageController: _pageController,
              profileUrl: profileUrl,
              widget: widget,
              userProjects: userProjects),
        ],
      ),
    );
  }
}
