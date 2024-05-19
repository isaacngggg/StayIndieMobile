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
    this.headline,
    this.bio,
    this.location,
    this.connectionsProfileIds = const [],
    this.socialMetrics = const [],
    this.profileColor = kBackgroundColour,
    this.spotifyArtistId,
    this.chatIds = const [],
    this.connectionsProfiles = const [],
    // this.coverButton,
  });

  final String id;
  final String username;
  final String name;
  final String? headline;
  final String? bio;
  final String? location;
  final DateTime createdAt;
  final List<String> connectionsProfileIds;
  late String profileImageUrl;
  List<SocialMetric>? socialMetrics;
  final Color profileColor;
  final String? spotifyArtistId;
  final List<Profile> connectionsProfiles;
  List<String> chatIds = [];

  static Map<String, Profile> _profileCache = {};

  // final String? coverButton;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        name = map['name'] == null ? map['username'] : map['name'],
        headline = map['headline'],
        bio = map['bio'],
        location = map['location'],
        connectionsProfileIds = map['connections'] == null
            ? []
            : (map['connections'] as List<dynamic>)
                .map((item) => item.toString())
                .toList(),
        chatIds = map['chats'] == null
            ? []
            : (map['chats'] as List<dynamic>)
                .map((item) => item.toString())
                .toList(),
        connectionsProfiles = [],
        createdAt = DateTime.parse(map['created_at']),
        profileColor = map['profile_color'] != null
            ? Color(int.parse(map['profile_color']))
            : kBackgroundColour10,
        spotifyArtistId = map['spotify_artist_id'],
        profileImageUrl = map['profile_image_url'] ??
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  static Map<String, dynamic> toJson(Profile profile) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = profile.id;
    data['username'] = profile.username;
    data['name'] = profile.name;
    data['headline'] = profile.headline;
    data['bio'] = profile.bio;
    data['location'] = profile.location;
    data['connections'] = profile.connectionsProfileIds;
    data['created_at'] = profile.createdAt.toIso8601String();
    data['profile_color'] = profile.profileColor.hashCode.toString();
    data['spotify_artist_id'] = profile.spotifyArtistId;
    data['profile_image_url'] = profile.profileImageUrl;
    data['chats'] = profile.chatIds;
    return data;
  }

  static Future<void> saveToPrefs(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileData =
        jsonEncode(toJson(profile)); // Assuming you have a toJson method
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
        .getPublicUrl(currentUserProfile.id + '/profile' + '.png');
    _profileCache[userId] = currentUserProfile;
    await saveToPrefs(currentUserProfile);
    return currentUserProfile;
  }

  Future updateProfileImage() async {
    profileImageUrl = supabase.storage
        .from('profile_images')
        .getPublicUrl(id + '/profile' + '.png');
    _profileCache[id] = this;
  }

  static Future<Profile> getProfileData(String userId) async {
    if (userId == currentUserId) {
      return getCurrentUserProfile(userId);
    } else if (_profileCache.containsKey(userId)) {
      print('Profile cache hit: ' + _profileCache[userId]!.id);
      return _profileCache[userId]!;
    } else {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();

      Profile userProfile = Profile.fromMap(response);
      userProfile.profileImageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(userId + '/profile' + '.png');
      _profileCache[userId] = userProfile;
      print('Profile cache stored ' + userId);
      return userProfile;
    }
  }

  static Future<Profile> getCurrentUserProfile(String profileId) async {
    // removeProfileFromPrefs();
    Profile? profile = await Profile.loadFromPrefs();
    if (profile == null) {
      profile = await fetchProfileFromDatabase(profileId);
      await saveToPrefs(profile);
    }
    profile.updateConnections();
    return profile;
  }

  static Future<void> removeProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
  }

  static Future<void> updateProfile(String id, Map updatedProfile) async {
    try {
      print('Updating profile' + updatedProfile.toString());
      final response = await supabase
          .from('profiles')
          .update(
            updatedProfile,
          )
          .eq('id', id);

      await getProfileData(id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static void addConnection(ConnectionRequest request) async {
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

  void updateConnections() async {
    for (var connectionId in connectionsProfileIds) {
      Profile connection = await getProfileData(connectionId);
      connectionsProfiles.add(connection);
    }
  }

  static void clearCache() {
    _profileCache = {};
  }

  static Future<Profile?> searchProfileByUsername(String username) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('username', username)
          .single();
      Profile profile = Profile.fromMap(response);
      profile.updateProfileImage();

      return profile;
    } catch (e) {
      print('No profile matching ${username}' + e.toString());
      return null;
    }
  }

  static Future<List<Profile>> searchConnectionByName(
      String name, Profile profile) async {
    try {
      final results = profile.connectionsProfiles.where((connection) {
        return connection.name!.toLowerCase().contains(name.toLowerCase());
      }).toList();
      return results;
    } catch (e) {
      print('No profile matching ${name}' + e.toString());
      return [];
    }
  }

  static Future<bool> checkIfProfileIsSetUp() async {
    final profile = await Profile.loadFromPrefs();
    if (profile == null) {
      return false;
    }
    if (profile.name == null || profile.name == '') {
      return false;
    }
    if (profile.headline == null || profile.headline == '') {
      return false;
    }
    if (profile.bio == null || profile.bio == '') {
      return false;
    }
    if (profile.location == null || profile.location == '') {
      return false;
    }
    return true;
  }
}
