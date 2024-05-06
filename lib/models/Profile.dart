import 'package:flutter/material.dart';
import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/constants.dart';
import 'ConnectionRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  static Map<String, Profile> _profileCache = {};

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
        spotifyArtistId = map['spotify_artist_id'],
        profileImageUrl = map['profile_image_url'] ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['headline'] = headline;
    data['bio'] = bio;
    data['location'] = location;
    data['connections'] = connectionsProfileIds;
    data['created_at'] = createdAt.toIso8601String();
    data['profile_color'] = profileColor.hashCode.toString();
    data['spotify_artist_id'] = spotifyArtistId;
    data['profile_image_url'] = profileImageUrl;

    return data;
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData =
        jsonEncode(toJson()); // Assuming you have a toJson method
    await prefs.setString('profile', profileData);
  }

  static Future<Profile?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString('profile');
    if (profileData != null) {
      return Profile.fromMap(
          jsonDecode(profileData)); // Assuming you have a fromJson method
    }
    return null;
  }

  static Future<Profile> fetchProfileFromDatabase(userId) async {
    final response =
        await supabase.from('profiles').select().eq('id', userId).single();

    Profile currentUserProfile = Profile.fromMap(response);
    currentUserProfile.profileImageUrl = supabase.storage
        .from('profile_images')
        .getPublicUrl(currentUserProfile.id + '.png');
    _profileCache[userId] = currentUserProfile;
    return currentUserProfile;
  }

  static Future<Profile> getProfileData(userId) async {
    if (userId == currentUserId) {
      return getCurrentUserProfile(userId);
    } else if (_profileCache.containsKey(userId)) {
      print('Profile cache hit ' + userId);
      return _profileCache[userId]!;
    } else {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();

      Profile currentUserProfile = Profile.fromMap(response);
      currentUserProfile.profileImageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(currentUserProfile.id + '.png');
      _profileCache[userId] = currentUserProfile;
      print('Profile cache stored ' + userId);
      return currentUserProfile;
    }
  }

  static Future<Profile> getCurrentUserProfile(String profileId) async {
    // removeProfileFromPrefs();
    Profile? profile = await Profile.loadFromPrefs();
    if (profile == null) {
      profile = await fetchProfileFromDatabase(profileId);
      await profile.saveToPrefs();
    }
    return profile;
  }

  static Future<void> removeProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
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
}
