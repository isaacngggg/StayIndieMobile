import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stay_indie/constants.dart';

import 'Profile.dart';

import 'Message.dart';

class ChatInfo {
  final String id;
  final List<String> participants;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<Profile> participantProfiles;
  Message? lastMessage;

  ChatInfo({
    required this.id,
    required this.participants,
    required this.name,
    this.description,
    this.imageUrl,
    required this.participantProfiles,
    this.lastMessage,
  });

  // ChatInfo.fromMap(Map<String, dynamic> map)
  //     : id = map['id'],
  //       participants = map['participants'] as List<String>,
  //       name = map['name'] ?? 'Unnamed group chat',
  //       description = map['description'],
  //       imageUrl = map['image_url'],
  //       participantProfiles = [];

  static Map<String, dynamic> toJson(ChatInfo chatInfo) => {
        'id': chatInfo.id,
        'participants': chatInfo.participants,
        'name': chatInfo.name,
        'description': chatInfo.description,
        'image_url': chatInfo.imageUrl,
      };

  static Future<ChatInfo?> getConversationContaining(
      List<String> participants) async {
    try {
      print('Getting conversation by participants ' + participants.toString());
      final responses = await supabase
          .from('chats')
          .select()
          .filter('participants', 'cs', participants);
      var response = responses.toList()[0];
      if (response.isEmpty) {
        print('No chat found');
        return null;
      } else {
        List<String> participantIds =
            (response['participants'] as List<dynamic>)
                .map((item) => item.toString())
                .toList();

        if (!participants
            .every((participant) => participantIds.contains(participant))) {
          print('No chat found');
          return null;
        }
        print('response: ' + response.toString());
        return createChatInfo(response);
      }
    } catch (e) {
      print('Error getting conversation by participants ' + e.toString());
      return null;
    }
  }

  static Future<ChatInfo> createChatInfo(Map<String, dynamic> map) async {
    try {
      print('creating chat info' + map.toString());
      List<String> participantIds = (map['participants'] as List<dynamic>)
          .map((item) => item.toString())
          .toList();
      print('participantIds: ' + participantIds.toString());
      List<Profile> participantProfiles = [];

      for (var participant in participantIds) {
        await Profile.getProfileData(participant).then((profile) {
          participantProfiles.add(profile);
        });
      }
      Message? lastMessage;
      await Message.getLatestMessage(map['id']).then((message) {
        lastMessage = message;
      });
      print('participantProfiles: ' + participantProfiles.length.toString());
      if (participantProfiles.length > 2) {
        var chatInfo = ChatInfo(
          id: map['id'],
          participants: participantIds,
          name: map['name'] == null ? map['name'] : 'Unnamed group chat',
          participantProfiles: participantProfiles,
          lastMessage: lastMessage,
        );
        await saveToPrefs(chatInfo);
        return chatInfo;
      } else {
        print('participantProfiles: ' + participantProfiles.length.toString());
        Profile? dmProfile;
        for (var profile in participantProfiles) {
          if (profile.id != currentUserId) {
            dmProfile = profile;
            print('dmProfile: ' + dmProfile.name);
          }
        }
        var chatInfo = ChatInfo(
          id: map['id'],
          participants: participantIds,
          name: map['name'] == null ? dmProfile!.name : map['name'],
          description: map['description'],
          imageUrl: map['image_url'] == null
              ? dmProfile!.profileImageUrl
              : map['image_url'],
          participantProfiles: participantProfiles,
          lastMessage: lastMessage,
        );
        await saveToPrefs(chatInfo);
        return chatInfo;
      }
    } catch (e) {
      print('Error creating chat info ' + e.toString());
      throw e;
    }
  }

  static Future<ChatInfo?> getConversationFromSupabaseById(
      String chatId) async {
    try {
      print('Supabase Pulling for chat ' + chatId);
      final response =
          await supabase.from('chats').select().eq('id', chatId).single();
      return await ChatInfo.createChatInfo(response);
    } catch (e) {
      print('Error getting chat ' + e.toString());
      return null;
    }
  }

  static Future<ChatInfo?> getConversationById(String chatId) async {
    try {
      ChatInfo? chatInfo = await loadFromPrefs(chatId); // Await the result
      if (chatInfo != null) {
        print('Chat info found in prefs');
        print('Pref Chat Info: ${chatInfo.toString()}');
        return chatInfo;
      } else {
        print('Chat info not found in prefs');
        return await getConversationFromSupabaseById(chatId); // Await here too
      }
    } catch (e) {
      print('Error getting chat by id: $e');
      return null;
    }
  }

  static Future<List<ChatInfo>> getUserChats(String currentUserId) async {
    try {
      final response = await supabase
          .from('chats')
          .select()
          .filter('participants', 'cs', {currentUserId});

      if (response.isEmpty) {
        print('No chats found');
        return [];
      }

      List<ChatInfo> chats = [];

      for (var chat in response.toList()) {
        print('Chat: ' + chat.toString());
        List<String> participentId = (chat['participants'] as List<dynamic>)
            .map((item) => item.toString())
            .toList();
        List<Profile> participantProfiles = [];
        for (var participant in participentId) {
          await Profile.getProfileData(participant).then((profile) {
            participantProfiles.add(profile);
          });
        }
        if (participantProfiles.length == 2) {
          for (var profile in participantProfiles) {
            if (profile.id != currentUserId) {
              ChatInfo newChatInfo = ChatInfo(
                  id: chat['id'],
                  participants: participentId,
                  name: profile.name,
                  description: chat['description'],
                  imageUrl: profile.profileImageUrl,
                  participantProfiles: participantProfiles);
              newChatInfo.getLastMessage();
              chats.add(newChatInfo);
            }
          }
        } else {
          ChatInfo newChatInfo = ChatInfo(
              id: chat['id'],
              participants: participentId,
              name: 'Unnamed group chat',
              description: chat['description'],
              imageUrl: chat['image_url'],
              participantProfiles: participantProfiles);

          newChatInfo.getLastMessage();
          chats.add(newChatInfo);
        }
      }
      print('Chats: ' + chats.length.toString());
      return chats;
    } catch (e) {
      print('Error getting chats ' + e.toString());
      return [];
    }
  }

  static Future<ChatInfo?> createChat(List<String> participants) async {
    try {
      await supabase.from('chats').insert({
        'participants': participants,
      });
      return getConversationContaining(participants);
    } catch (e) {
      print('Error creating chat ' + e.toString());
      return null;
    }
  }

  static Future<ChatInfo?> dmBehaviour(List<String> participants) async {
    try {
      final chat = await getConversationContaining(participants);
      if (chat == null) {
        return createChat(participants);
      } else {
        return chat;
      }
    } catch (e) {
      print('Error dmBehavior function ' + e.toString());
      return null;
    }
  }

  void getLastMessage() async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('chat_id', id)
          .order('created_at', ascending: false)
          .single();

      if (response == null) {
        print('No messages found');
        return null;
      }
      lastMessage = Message.fromMap(map: response);
    } catch (e) {
      print('Error getting last message ' + e.toString());
      return null;
    }
  }

  static Future<void> saveToPrefs(ChatInfo chatInfo) async {
    print('Saving chat info to prefs');
    final prefs = await SharedPreferences.getInstance();
    final chatInfoString = jsonEncode(toJson(chatInfo));
    prefs.setString(chatInfo.id, chatInfoString);
  }

  static Future<ChatInfo?> loadFromPrefs(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final chatInfoString = prefs.getString(chatId);
    if (chatInfoString == null) {
      return null;
    }
    return ChatInfo.createChatInfo(jsonDecode(chatInfoString));
  }

  static Future<void> removeAllFromPrefs() async {
    final prefs = SharedPreferences.getInstance();
    await prefs.then((value) => value.clear());
  }

  static Future<void> deleteChat(String chatId) async {
    try {
      await supabase.from('chats').delete().eq('id', chatId);
    } catch (e) {
      print('Error deleting chat ' + e.toString());
    }
  }

  String toString() {
    return 'ChatInfo: id: $id, participants: $participants, name: $name, description: $description, imageUrl: $imageUrl, participantProfiles: $participantProfiles, lastMessage: $lastMessage';
  }
}
