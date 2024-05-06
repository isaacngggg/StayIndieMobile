import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/Chat.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/screens/profile/MainProfilePage.dart';
import 'package:stay_indie/screens/profile/content_page.dart';

class ChatInfoScreen extends StatefulWidget {
  final Chat chatInfo;
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
          ListTile(
            title: Text('Chat Name'),
            subtitle: Text(widget.chatInfo.name),
          ),
          ListTile(
            title: Text('Description'),
            subtitle: Text(widget.chatInfo.description ?? 'No description'),
          ),
          ListTile(
            title: Text(
              'Participants',
              style: kHeading3,
            ),
            subtitle: Container(
              clipBehavior: Clip.antiAlias,
              decoration: kOutlineBorder.copyWith(
                borderRadius: BorderRadius.circular(20),
                color: kPrimaryColour20,
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
                        tileColor: kPrimaryColour20,
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
          ),
        ],
      ),
    );
  }
}
