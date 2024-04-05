import 'package:stay_indie/constants.dart';

import 'Profile.dart';

import 'Message.dart';

class Chat {
  final String id;
  final List<String> participants;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<Profile> participantProfiles;
  Message? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    required this.name,
    this.description,
    this.imageUrl,
    required this.participantProfiles,
  });

  Chat.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        participants = map['participants'],
        name = map['name'],
        description = map['description'],
        imageUrl = map['image_url'],
        participantProfiles = map['participantProfiles'];

  static Future<List<Chat>> getChats(String currentUserId) async {
    try {
      final response = await supabase
          .from('chats')
          .select()
          .filter('participants', 'cs', {currentUserId});

      if (response.isEmpty) {
        print('No chats found');
        return [];
      }

      List<Chat> chats = [];

      for (var chat in response.toList()) {
        print('Chat: ' + chat.toString());
        List<String> participentId = (chat['participants'] as List<dynamic>)
            .map((item) => item.toString())
            .toList();
        List<Profile> participantProfiles = [];
        for (var participant in participentId) {
          await Profile.getProfileData(participant).then((profile) {
            participantProfiles.add(profile!);
            print('Profile: ' + profile.name);
          });
        }
        if (participantProfiles.length == 2) {
          for (var profile in participantProfiles) {
            print('Profile: ' + profile.name);
            if (profile.id != currentUserId) {
              print('Profile: ' + profile.name);
              chats.add(Chat(
                  id: chat['id'],
                  participants: participentId,
                  name: profile.name,
                  description: chat['description'],
                  imageUrl: chat['image_url'],
                  participantProfiles: participantProfiles));
            }
          }
        } else {
          chats.add(Chat(
              id: chat['id'],
              participants: participentId,
              name: 'Unnamed group chat',
              description: chat['description'],
              imageUrl: chat['image_url'],
              participantProfiles: participantProfiles));
        }
      }
      print('Chats: ' + chats.length.toString());
      return chats;
    } catch (e) {
      print('Error getting chats ' + e.toString());
      return [];
    }
  }
}
