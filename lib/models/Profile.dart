import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/constants.dart';
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
    required this.profileImagePath,
    required this.connectionsProfileIds,
    this.profileImageUri,
    this.socialMetrics = const [],
  });

  final String id;
  final String username;
  final String name;
  final String headline;
  final String bio;
  final String location;
  final DateTime createdAt;
  final List<String> connectionsProfileIds;
  final String profileImagePath;
  final Uri? profileImageUri;
  List<SocialMetric>? socialMetrics;

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
        profileImagePath = map['profile_image_path'],
        profileImageUri = map['profile_image_uri'],
        createdAt = DateTime.parse(map['created_at']);

  static Future<Profile?> getProfileData(userId) async {
    try {
      final response =
          await supabase.from('profiles').select().eq('id', userId).single();

      if (response.isNotEmpty) {
        Profile currentUserProfile = Profile.fromMap(response);
        return currentUserProfile;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user Profile' + e.toString());
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
}
