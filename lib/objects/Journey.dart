import 'package:stay_indie/constants.dart';

class Journey {
  final String title;
  final String organization;
  final String description;
  final String startDate;
  final String? endDate;
  final List<String>? images;
  final List<String>? collaborators;
  final List<String>? tags;

  Journey({
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
      : title = map['title'],
        organization = map['organization'],
        description = map['description'],
        startDate = map['start_date'].toString(),
        endDate = map['end_date'].toString(),
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
}
