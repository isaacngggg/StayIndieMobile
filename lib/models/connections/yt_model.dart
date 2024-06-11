import 'package:stay_indie/models/SocialMetric.dart';

import 'package:stay_indie/constants.dart';

class Youtube {
  final String? id;
  final String? name;
  final String? description;

  Youtube({this.id, this.name, this.description});

  factory Youtube.fromMap(Map<String, dynamic> json) {
    return Youtube(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  static Future<SocialMetric?> getFromSupabaseResponse(String id) async {
    final response =
        await supabase.from('yt_channels').select().eq('user_id', id).single();

    if (response.isNotEmpty) {
      print('Yt Supabase response: not empty');
      return SocialMetric(
        name: 'youtube',
        value: formatLargeNumber(response['subscriber_count']).toString(),
        unit: 'subscribers',
      );
    } else {
      print('Yt Supabase response: nothing found');
      return null;
    }
  }
}
