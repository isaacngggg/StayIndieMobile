import 'package:stay_indie/constants.dart';

class Organisation {
  final String? id;
  final String name;
  final String description;

  Organisation({
    this.id,
    required this.name,
    required this.description,
  });

  Organisation.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'];

  static Future<List<Organisation>> getOrganisations() async {
    try {
      final response = await supabase.from('organisations').select();
      if (response.isEmpty) {
        print('No organisations found');
        return [];
      }
      List<Organisation> organisations = [];
      for (var organisation in response.toList()) {
        organisations.add(Organisation.fromMap(organisation));
      }
      return organisations;
    } catch (e) {
      print('Error getting organisation' + e.toString());
      return [];
    }
  }

  static addOrganisation(Organisation organisation) async {
    try {
      final response = await supabase.from('organizations').upsert({
        'name': organisation.name,
        'description': organisation.description,
      });
      if (response.error != null) {
        print('Error' + response);
      } else {
        print('Organization added');
      }
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  static getAvatarImageUrl(String organisationId) async {
    try {
      final response = await supabase.storage
          .from('profile_images')
          .getPublicUrl('/$organisationId.png');
      if (response.isEmpty) {
        print('No avatar image found');
        return null;
      }
      return response.toString();
    } catch (e) {
      print('Error' + e.toString());
      return null;
    }
  }
}
