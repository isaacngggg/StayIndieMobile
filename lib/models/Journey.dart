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
        imagesUrls =
            []; // Add an initializer expression for the imagesUrls field

  void initializeImagesUrls() {
    Project.getProjectImages(id, currentUserId)
        .then((value) => imagesUrls = value);
  }

  static Future<List<Journey>> getCurrentUserJourneys() async {
    final currentUser = supabase.auth.currentUser;
    try {
      print(currentUser!.id);
      final response = await supabase
          .from('journey_entries')
          .select()
          .eq('profile_id', currentUser.id);

      if (response.isEmpty) {
        print('No journeys found');
        return [];
      }
      List<Journey> journeys = [];
      for (var journey in response.toList()) {
        Journey newJourney = Journey.fromMap(journey);
        newJourney.initializeImagesUrls();
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

  static Future<void> deleteJourney(Journey journey) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      print('No user found');
      return;
    }
    try {
      await supabase
          .from('journey_entries')
          .delete()
          .eq('id', journey.id.toString());
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
}
