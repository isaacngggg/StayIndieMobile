import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';

import 'package:stay_indie/models/Chat.dart';

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
      appBar: AppBar(title: Text(widget.chatInfo.name)),
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
            title: Text('Participants'),
            subtitle: Column(
              children: [
                for (var profile in widget.chatInfo.participantProfiles)
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(profile.username.substring(0, 2)),
                    ),
                    title: Text(profile.username),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
