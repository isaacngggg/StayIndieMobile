import 'package:stay_indie/objects/SocialMetric.dart';
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
        profileImagePath = map['profile_image_path'],
        profileImageUri = map['profile_image_uri'],
        createdAt = DateTime.parse(map['created_at']);

  static Future<Profile?> getProfileData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      final response =
          await supabase.from('profiles').select().eq('id', user.id).single();
      if (response.isNotEmpty) {
        Profile currentUserProfile = Profile.fromMap(response);
        print(currentUserProfile);
        return currentUserProfile;
      } else {
        return null;
      }
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static updateProfile(Profile updatedProfile) async {
    // Update the profiles
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      print('Updating profile' + updatedProfile.toString());
      final response = await supabase.from('profiles').update(
        {
          'name': updatedProfile.name,
          'headline': updatedProfile.headline,
          'bio': updatedProfile.bio,
          'location': updatedProfile.location,
        },
      ).eq('id', user.id);
    } catch (e) {
      print('Error' + e.toString());
    }
  }
}
