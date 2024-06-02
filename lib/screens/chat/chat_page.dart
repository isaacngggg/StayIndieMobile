import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/chat_info.dart';
import 'package:stay_indie/models/Message.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/widgets/chat/message_bar.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/widgets/chat/ChatBubble.dart';
import 'package:stay_indie/screens/chat/chat_info_screen.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({required this.chatId, Key? key}) : super(key: key);

  static const String id = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};

  late Future<ChatInfo?> thisChat;

  @override
  void initState() {
    thisChat = ChatInfo.getConversationById(widget.chatId);

    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', widget.chatId)
        .order('created_at')
        .map((maps) => maps.map((map) => Message.fromMap(map: map)).toList());
    super.initState();
  }

  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache[profileId] != null) {
      return;
    }
    final data =
        await supabase.from('profiles').select().eq('id', profileId).single();
    final profile = Profile.fromMap(data);
    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: thisChat,
        builder: (context, snapshot) {
          print('Snapshot: ' + snapshot.data.toString());
          // Your code here
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            ChatInfo chatInfo = snapshot.data as ChatInfo;
            print(chatInfo.toString());
            for (var profile in chatInfo.participantProfiles) {
              print(profile.name);
            }
            List<String> participants = [];
            chatInfo.participantProfiles.forEach((profile) {
              participants.add(profile.name);
            });
            print(chatInfo.name);
            print(participants);
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatInfoScreen(
                        chatInfo: snapshot.data as ChatInfo,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      chatInfo.imageUrl == null
                          ? const CircleAvatar(
                              radius: 20,
                              child: FaIcon(FontAwesomeIcons.user),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(chatInfo.imageUrl!),
                            ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatInfo.name,
                              style: kHeading3,
                            ),
                            const SizedBox(width: 8),
                            chatInfo.participants.length == 2
                                ? Container()
                                : Text(
                                    '${participants.toString().replaceAll('[', '').replaceAll(']', '')}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: StreamBuilder<List<Message>>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!;
                    return Column(
                      children: [
                        Expanded(
                          child: messages.isEmpty
                              ? const Center(
                                  child: Text('Start your conversation now :)'),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];

                                    /// I know it's not good to include code that is not related
                                    /// to rendering the widget inside build method, but for
                                    /// creating an app quick and dirty, it's fine 😂
                                    _loadProfileCache(message.senderId);

                                    return ChatBubble(
                                      message: message,
                                      profile: _profileCache[message.senderId],
                                      isGroupChat:
                                          chatInfo.participants.length > 2,
                                    );
                                  },
                                ),
                        ),
                        MessageBar(chatId: chatInfo.id),
                      ],
                    );
                  } else {
                    return preloader;
                  }
                },
              ),
            );
          } else {
            return Scaffold(
              body: const Center(
                child: Text('An error occurred'),
              ),
            );
          }
        });
  }
}
