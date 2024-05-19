import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Message.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:timeago/timeago.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
    required this.isGroupChat,
  }) : super(key: key);

  final Message message;
  final Profile? profile;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine && isGroupChat)
        CircleAvatar(
          child: profile == null
              ? preloader
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine ? kPrimaryColour20 : kBackgroundColour20,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: message.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: message.isMine ? kBackgroundColour10 : kPrimaryColour,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                format(message.createdAt, locale: 'en_short'),
                style: TextStyle(
                  fontSize: 10,
                  color: message.isMine ? kPrimaryColour50 : kPrimaryColour50,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
