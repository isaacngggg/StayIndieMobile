import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/ChatInfo.dart';
import 'package:stay_indie/models/Profile.dart';

import 'package:stay_indie/screens/archive/content_page.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';

class ChatInfoScreen extends StatefulWidget {
  final ChatInfo chatInfo;
  const ChatInfoScreen({required this.chatInfo, Key? key}) : super(key: key);

  static const String id = 'chat_info_screen';

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Info')),
      body: Column(
        children: [
          widget.chatInfo.participants.length != 2
              ? ListTile(
                  title: Text('Chat Name'),
                  subtitle: Text(widget.chatInfo.name),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Participants', style: kHeading3),
                SizedBox(height: 10),
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: kOutlineBorder.copyWith(
                    borderRadius: BorderRadius.circular(20),
                    color: kBackgroundColour10,
                  ),
                  child: Column(
                    children: [
                      for (var profile in widget.chatInfo.participantProfiles)
                        ListTile(
                            shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                0.5),
                            tileColor: kBackgroundColour10,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(profile.profileImageUrl),
                              child: profile.profileImageUrl == null
                                  ? Text(profile.name.substring(0, 2))
                                  : null,
                            ),
                            title: Text(profile.name),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(profileId: profile.id)));
                            },
                            trailing: currentUserId == profile.id ||
                                    currentUserProfile!.connectionsProfileIds
                                        .contains(profile.id)
                                ? null
                                : TextButton(
                                    style: kSmallPrimaryButtonStyle,
                                    child: Text('Follow'),
                                    onPressed: () => null,
                                  )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
