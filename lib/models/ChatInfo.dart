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
        return ChatInfo(
          id: map['id'],
          participants: participantIds,
          name: map['name'] == null ? map['name'] : 'Unnamed group chat',
          participantProfiles: participantProfiles,
          lastMessage: lastMessage,
        );
      } else {
        print('participantProfiles: ' + participantProfiles.length.toString());
        Profile? dmProfile;
        for (var profile in participantProfiles) {
          if (profile.id != currentUserId) {
            dmProfile = profile;
            print('dmProfile: ' + dmProfile.name);
          }
        }
        return ChatInfo(
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
      }
    } catch (e) {
      print('Error creating chat info ' + e.toString());
      throw e;
    }
  }

  static Future<ChatInfo> getConversationById(String chatId) async {
    try {
      final response =
          await supabase.from('chats').select().eq('id', chatId).single();

      if (response == null) {
        print('No chat found');
        return ChatInfo(
            id: '0',
            participants: [],
            name: 'Unnamed group chat',
            participantProfiles: []);
      }

      List<String> participentId = (response['participants'] as List<dynamic>)
          .map((item) => item.toString())
          .toList();
      List<Profile> participantProfiles = [];
      for (var participant in participentId) {
        await Profile.getProfileData(participant).then((profile) {
          participantProfiles.add(profile!);
        });
      }

      return ChatInfo(
          id: response['id'],
          participants: participentId,
          name: response['name'],
          description: response['description'],
          imageUrl: response['image_url'],
          participantProfiles: participantProfiles);
    } catch (e) {
      print('Error getting chat ' + e.toString());
      return ChatInfo(
          id: '0',
          participants: [],
          name: 'Unnamed group chat',
          participantProfiles: []);
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
}
