import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Chat.dart';
import 'package:stay_indie/models/Message.dart';
import 'package:stay_indie/models/Profile.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stay_indie/widgets/chat/ChatBubble.dart';
import 'package:stay_indie/screens/chat/chat_info_screen.dart';

class ChatScreen extends StatefulWidget {
  final Chat chatInfo;
  const ChatScreen({required this.chatInfo, Key? key}) : super(key: key);

  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};

  @override
  void initState() {
    final myUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', widget.chatInfo.id)
        .order('created_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(map: map, myUserId: myUserId))
            .toList());
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatInfo.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatInfoScreen(chatInfo: widget.chatInfo);
              }));
            },
          ),
        ],
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
                            );
                          },
                        ),
                ),
                _MessageBar(chatId: widget.chatInfo.id),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  final String chatId;
  const _MessageBar({
    required this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitMessage(),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;
    final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('messages').insert({
        'sender_id': myUserId,
        'content': text,
        'chat_id': widget.chatId, // Replace with actual chat id
      });
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: 'Unexpected error occurred');
    }
  }
}
