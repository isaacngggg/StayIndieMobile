import 'package:stay_indie/constants.dart';

class Journey {
  final String? id;
  final String title;
  final String organization;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  Journey({
    this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.startDate,
    this.endDate,
    this.images,
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
        images = map['images'],
        collaborators = map['collaborators'],
        tags = map['tags'];

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
        journeys.add(Journey.fromMap(journey));
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

  static Future<void> updateJourney(Journey journey) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      print('No user found');
      return;
    }
    try {
      await supabase.from('journey_entries').update({
        'title': journey.title,
        'organization': journey.organization,
        'description': journey.description,
        'start_date': journey.startDate.toIso8601String(),
        'profile_id': currentUser.id,
      }).eq('id', journey.id.toString());
    } catch (e) {
      print('Error' + e.toString());
    }
  }

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
}
