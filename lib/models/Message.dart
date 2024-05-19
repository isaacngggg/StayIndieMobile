import 'package:stay_indie/constants.dart';

class Message {
  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.chatId,
  });

  /// ID of the message
  final String id;

  /// ID of the user who posted the message
  final String senderId;

  /// Text content of the message
  final String content;

  /// Date and time when the message was created
  final DateTime createdAt;

  /// Whether the message is sent by the user or not.
  final bool isMine;

  final String chatId;

  Message.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        senderId = map['sender_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = map['sender_id'] == currentUserId,
        chatId = map['chat_id'];

  static Future<List<Message>> getMessages(String chatId) async {
    final response = await supabase
        .from('messages')
        .select()
        .filter('chat_id', 'eq', chatId)
        .order('created_at', ascending: false);

    List<Message> messages = [];

    for (var message in response.toList()) {
      messages.add(Message.fromMap(map: message));
    }

    return messages;
  }

  static Future<void> sendMessage({
    required String chatId,
    required String content,
  }) async {
    final response = await supabase.from('messages').upsert([
      {
        'chat_id': chatId,
        'sender_id': currentUserId,
        'content': content,
      }
    ]);

    if (response.error != null) {
      print('Error sending message: ${response.error!.message}');
    }
  }

  static Future<Message> getLatestMessage(String chatId) async {
    final response = await supabase
        .from('messages')
        .select()
        .filter('chat_id', 'eq', chatId)
        .order('created_at', ascending: false)
        .limit(1);

    Message message = Message.fromMap(map: response[0]);

    return message;
  }
}
