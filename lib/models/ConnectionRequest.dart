import 'dart:ffi';

import 'package:stay_indie/constants.dart';

class ConnectionRequest {
  String id;
  String senderId;
  String receiverId;
  bool accepted;
  String createdAt;

  ConnectionRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.accepted,
    required this.createdAt,
  });

  ConnectionRequest.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        senderId = map['sender_id'],
        receiverId = map['receiver_id'],
        accepted = map['accepted'],
        createdAt = map['created_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['status'] = accepted;
    data['created_at'] = createdAt;
    return data;
  }

  static Future<List<ConnectionRequest>> getProfileConnectionRequests(
      String profileId) async {
    final response = await supabase
        .from('connection_requests')
        .select()
        .eq('receiver_id', profileId);

    if (response.isEmpty) {
      print('No connection requests found for $profileId');
      return [];
    }
    return response == null
        ? []
        : response.map((map) => ConnectionRequest.fromMap(map)).toList();
  }

  static void requestFollowProfile(String profileId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      final response = await supabase.from('connection_requests').upsert([
        {
          'sender_id': user.id,
          'receiver_id': profileId,
        }
      ]);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static Future<bool> isRequested(String profileId) async {
    try {
      print(
          'Checking if request is pending for $profileId from $currentUserId');
      final response = await supabase
          .from('connection_requests')
          .select()
          .eq('sender_id', currentUserId)
          .eq('receiver_id', profileId)
          .eq('accepted', false);
      if (response.isNotEmpty) {
        print('Request already sent');
        return true;
      } else {
        print('Request not sent');
        return false;
      }
    } catch (e) {
      print('Error with the isRequested Function' + e.toString());
      return false;
    }
  }

  static Future<bool> needToAccept(String profileId) async {
    try {
      print(
          'Checking if request is pending for $profileId from $currentUserId');
      final response = await supabase
          .from('connection_requests')
          .select()
          .eq('sender_id', profileId)
          .eq('receiver_id', currentUserId)
          .eq('accepted', false);
      if (response.isNotEmpty) {
        // print('Need to accept');
        return true;
      } else {
        print('Request not sent');
        return false;
      }
    } catch (e) {
      print('Error with the needToAccepts Function' + e.toString());
      return false;
    }
  }
}
