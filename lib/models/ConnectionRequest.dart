import 'package:stay_indie/constants.dart';

class ConnectionRequest {
  String id;
  String senderId;
  String receiverId;
  bool accepted;
  String createdAt;

  // static Map<String, ConnectionRequest> _connectionRequestCache = {};
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
        .eq('receiver_id', profileId)
        .eq('accepted', false);

    if (response.isEmpty) {
      print('No connection requests found for $profileId');
      return [];
    }
    return response.map((map) => ConnectionRequest.fromMap(map)).toList();
  }

  static void sendRequest(String profileId) async {
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
          'Checking if $currentUserId need to accept request from $profileId');
      final response = await supabase
          .from('connection_requests')
          .select()
          .eq('sender_id', profileId)
          .eq('receiver_id', currentUserId)
          .eq('accepted', false);
      if (response.isNotEmpty) {
        print('$currentUserId need to accept request from $profileId');
        return true;
      } else {
        print('$currentUserId has nothing to accept from $profileId');
        return false;
      }
    } catch (e) {
      print('Error with the needToAccepts Function' + e.toString());
      return false;
    }
  }

  static void deleteRequest(String requestId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      await supabase.from('connection_requests').delete().eq('id', requestId);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static Future<ConnectionRequest?> getRequest(
      String sender_id, String receiver_id) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      final response = await supabase
          .from('connection_requests')
          .select()
          .eq('sender_id', sender_id)
          .eq('receiver_id', receiver_id);
      return response.isNotEmpty
          ? ConnectionRequest.fromMap(response.first)
          : null;
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static void acceptRequest(String requestId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      await supabase
          .from('connection_requests')
          .update({'accepted': true}).eq('id', requestId);
    } catch (e) {
      print('Error' + e.toString());
    }
  }
}
