import 'package:flutter/cupertino.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/Project.dart';
import 'package:uuid/uuid.dart';

class Journey {
  final String id;
  final String title;
  final String organization;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  List<String> imagesUrls;
  final List<String>? collaborators;
  final List<String>? tags;

  final String emoji;
  final Color emojiBgColor;

  Journey({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.startDate,
    this.endDate,
    this.imagesUrls = const [],
    this.collaborators,
    this.tags,
    this.emojiBgColor = kPrimaryColour,
    this.emoji = '🚀',
  });

  Journey.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        organization = map['organization'],
        description = map['description'],
        startDate = map['start_date'] is DateTime
            ? map['start_date']
            : DateTime.parse(map['start_date']),
        endDate = map['end_date'] is DateTime
            ? map['end_date']
            : (map['end_date'] != null
                ? DateTime.parse(map['end_date'])
                : null),
        collaborators = map['collaborators'],
        tags = map['tags'],
        emoji = map['emoji'] ?? '🚀',
        emojiBgColor = map['emoji_bg_colo'] != null
            ? Color(int.parse(map['color'].toString()))
            : kPrimaryColour,
        imagesUrls =
            []; // Add an initializer expression for the imagesUrls field

  Future initializeImagesUrls(String userId) async {
    print('Getting images for journey: ' + id);
    await Project.getProjectImages(id, userId)
        .then((value) => imagesUrls = value);
  }

  static Future<List<Journey>> getUserJourneys(String userId) async {
    try {
      final response = await supabase
          .from('journey_entries')
          .select()
          .eq('profile_id', userId);

      if (response.isEmpty) {
        print('No journeys found');
        return [];
      }
      List<Journey> journeys = [];
      for (var journey in response.toList()) {
        Journey newJourney = Journey.fromMap(journey);
        print('Initializing images for journey: ' + newJourney.id);
        await newJourney.initializeImagesUrls(userId);
        journeys.add(newJourney);
      }
      return journeys;
    } catch (e) {
      print('Error' + e.toString());
      return [];
    }
  }

  static Future<void> addJourney(Journey journey) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      print('No user found');
      return;
    }
    try {
      await supabase.from('journey_entries').insert({
        'id': journey.id,
        'title': journey.title,
        'organization': journey.organization,
        'description': journey.description,
        'start_date': journey.startDate.toIso8601String(),
        'profile_id': currentUser.id,
      });
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  // static Future<void> updateJourney(Journey journey) async {
  //   final currentUser = supabase.auth.currentUser;
  //   if (currentUser == null) {
  //     print('No user found');
  //     return;
  //   }
  //   try {
  //     await supabase.from('journey_entries').update({
  //       'title': journey.title,
  //       'organization': journey.organization,
  //       'description': journey.description,
  //       'start_date': journey.startDate.toIso8601String(),
  //       'profile_id': currentUser.id,
  //     }).eq('id', journey.id.toString());
  //   } catch (e) {
  //     print('Error' + e.toString());
  //   }
  // }

  static Future<void> deleteJourney(String journeyId) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      print('No user found');
      return;
    }
    try {
      await supabase.from('journey_entries').delete().eq('id', journeyId);
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static Future<void> updateJourney(Map updatedJourney, String id) async {
    // Update the profiles
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('No user found');
      return null;
    }
    try {
      print('Updating journey' + updatedJourney.toString());
      final response = await supabase
          .from('journey_entries')
          .update(
            updatedJourney,
          )
          .eq('id', id);
      // await saveToPrefs();
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static Future<void> addImageUrl(String imageUrl, String journeyId) async {
    try {
      final response = await supabase.from('journey_entries').update({
        'images_Urls': supabase.rpc('array_append(images_urls), $imageUrl)'),
      }).eq('id', journeyId);
    } catch (e) {
      print('Error adding Image Url: ' + e.toString());
    }
  }

  static Future<void> removeImageUrl(String imageUrl, String journeyId) async {
    try {
      final response = await supabase.from('journey_entries').update({
        'images_Urls': supabase.rpc('array_remove(images_urls), $imageUrl)'),
      }).eq('id', journeyId);
    } catch (e) {
      print('Error removing Image Url: ' + e.toString());
    }
  }
}
