import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stay_indie/screens/chat/ChatScreen.dart';
import 'package:stay_indie/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Set of widget that contains TextField and Button to submit message
class MessageBar extends StatefulWidget {
  final String? chatId;
  final List<String>? participants;
  const MessageBar({
    this.chatId,
    this.participants,
    Key? key,
  }) : super(key: key);
  @override
  State<MessageBar> createState() => MessageBarState();
}

class MessageBarState extends State<MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBackgroundColour10,
      child: SafeArea(
        right: false,
        left: false,
        top: false,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackgroundColour30,
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _submitMessage(),
                color: kAccentColour,
                iconSize: 16,
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: kAccentColour,
                  child: const Icon(
                    Icons.send,
                    size: 16,
                    color: kPrimaryColour,
                  ),
                ),
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
