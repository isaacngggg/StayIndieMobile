import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/profile/profile_edit_page.dart';
import 'package:stay_indie/widgets/social/SocialMetricList.dart';
import 'package:stay_indie/screens/settings/settings_page.dart';
import 'package:stay_indie/models/ConnectionRequest.dart';

class ProfileCoverPage extends StatefulWidget {
  const ProfileCoverPage({
    super.key,
    required this.profileUrl,
    required this.userProfile,
  });

  final String profileUrl;
  final Profile userProfile;

  @override
  State<ProfileCoverPage> createState() => _ProfileCoverPageState();
}

class _ProfileCoverPageState extends State<ProfileCoverPage> {
  late bool isConnected = false;
  late bool requestPending;
  late bool recievedRequest;
  @override
  void initState() {
    // TODO: implement initState

    widget.userProfile.connectionsProfileIds.contains(currentUserId)
        ? isConnected = true
        : isConnected = false;

    supabase
        .from('connection_requests')
        .select()
        .eq('request_profile_id', currentUserId)
        .eq('target_profile_id', widget.userProfile.id)
        .then((value) => requestPending = value.isNotEmpty);

    supabase
        .from('connection_requests')
        .select()
        .eq('request_profile_id', currentUserId)
        .eq('target_profile_id', widget.userProfile.id)
        .then((value) => recievedRequest = value.isNotEmpty);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isCurrentUser = widget.userProfile.id == currentUserId;
    return Stack(
      children: [
        // Background image

        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.profileUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
        ),
        //Inner shadow
        GradientShadowOverlay(),
        // Content
        SafeArea(
          child: Container(
            clipBehavior: Clip.none,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(widget.userProfile.name,
                    style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Text(
                  widget.userProfile.headline,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.userProfile.bio,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                widget.userProfile.socialMetrics != null
                    ? SocialMetricList(
                        socialMetrics: widget.userProfile.socialMetrics!,
                      )
                    : Container(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _isCurrentUser
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProfileEditPage();
                                  }));
                                },
                                style: kPurpleButtonStyle,
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 249, 242, 242),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : coverPageButton(
                                widget.userProfile, true, () {})), // Add this
                    SizedBox(width: 10),
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.paperPlane),
                        onPressed: () {}),
                    SizedBox(width: 10),
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.arrowUpFromBracket),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Swipe up to see more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isCurrentUser
                      ? Spacer()
                      : IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                          ),
                        ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.2)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SettingPage.id);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.gear,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          top: 0,
          left: 0,
          right: 0,
        ),
      ],
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
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(1),
          ],
        ),
      ),
    );
  }
}

coverPageButton(Profile userProfile, bool isConnected, Function followUser) {
  if (isConnected) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              followUser();
            },
            style: kSecondaryButtonStyle,
            child: Text(
              'Connected',
              style: TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  } else {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            followUser();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Follow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10),
        TextButton(
          onPressed: () {
            followUser();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Message',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
