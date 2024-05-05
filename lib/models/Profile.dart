import 'package:flutter/material.dart';
import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/constants.dart';
import 'ConnectionRequest.dart';

class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.name,
    required this.headline,
    required this.bio,
    required this.location,
    required this.connectionsProfileIds,
    this.socialMetrics = const [],
    this.profileColor = kBackgroundColour,
    this.spotifyArtistId,
    // this.coverButton,
  });

  final String id;
  final String username;
  final String name;
  final String headline;
  final String bio;
  final String location;
  final DateTime createdAt;
  final List<String> connectionsProfileIds;
  late String profileImageUrl;
  List<SocialMetric>? socialMetrics;
  final Color profileColor;
  final String? spotifyArtistId;
  // final String? coverButton;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        name = map['name'],
        headline = map['headline'],
        bio = map['bio'],
        location = map['location'],
        connectionsProfileIds = map['connections'] == null
            ? []
            : (map['connections'] as List<dynamic>)
                .map((item) => item.toString())
                .toList(),
        createdAt = DateTime.parse(map['created_at']),
        profileColor = map['profile_color'] != null
            ? Color(int.parse(map['profile_color']))
            : kBackgroundColour10,
        spotifyArtistId = map['spotify_artist_id'];
  // coverButton = _getCoverButton(map['id']);

  static Future<String> _getCoverButton(String id) async {
    bool requestPending = false;
    bool receivedRequest = false;

    var value = await supabase
        .from('connection_requests')
        .select()
        .eq('request_profile_id', currentUserId)
        .eq('target_profile_id', id)
        .single();
    requestPending = value.isNotEmpty;

    value = await supabase
        .from('connection_requests')
        .select()
        .eq('request_profile_id', id)
        .eq('target_profile_id', currentUserId)
        .single();
    receivedRequest = value.isNotEmpty;

    if (receivedRequest) {
      print('Received request');
    }
    print('Request pending: ' + requestPending.toString());

    return requestPending ? 'Pending' : 'Connect';
  }

  static Future<Profile> getProfileData(userId) async {
    try {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();

      Profile currentUserProfile = Profile.fromMap(response);
      currentUserProfile.profileImageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(currentUserProfile.id + '.png');

      return currentUserProfile;
    } catch (e) {
      throw Exception('Error getting user Profile' + e.toString());
    }
  }

  static updateProfile(Map updatedProfile) async {
    // Update the profiles
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      print('Updating profile' + updatedProfile.toString());
      final response = await supabase
          .from('profiles')
          .update(
            updatedProfile,
          )
          .eq('id', user.id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static void acceptFollowRequest(ConnectionRequest request) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      final response = await supabase.from('profiles').update({
        'connections':
            supabase.rpc('array_append(connections, ${request.senderId})'),
      }).eq('profile_id', user.id);
      await supabase.from('connection_requests').delete().eq('id', request.id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static void rejectFollowRequest(ConnectionRequest request) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      await supabase.from('connection_requests').delete().eq('id', request.id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static void removeConnection(String profileId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      final response = await supabase.from('profiles').update({
        'connections': supabase.rpc('array_remove(connections, ${profileId})'),
      }).eq('profile_id', user.id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }
}
