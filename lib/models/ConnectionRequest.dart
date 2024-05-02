import 'package:stay_indie/constants.dart';

class ConnectionRequest {
  String id;
  String requestProfileId;
  String targetProfileId;
  String status;
  String createdAt;

  ConnectionRequest({
    required this.id,
    required this.requestProfileId,
    required this.targetProfileId,
    required this.status,
    required this.createdAt,
  });

  ConnectionRequest.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        requestProfileId = map['sender_id'],
        targetProfileId = map['receiver_id'],
        status = map['status'],
        createdAt = map['created_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = requestProfileId;
    data['receiver_id'] = targetProfileId;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
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
          'request_profile_id': user.id,
          'target_profile_id': profileId,
        }
      ]);
    } catch (e) {
      print('Error' + e.toString());
    }
  }
}
