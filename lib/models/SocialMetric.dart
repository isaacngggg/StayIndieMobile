import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMetric {
  final String name;
  final String value;
  final String unit;

  SocialMetric({required this.name, required this.value, required this.unit});

  factory SocialMetric.fromJson(Map<String, dynamic> json) {
    return SocialMetric(
      name: json['name'],
      value: json['value'],
      unit: json['unit'],
    );
  }

  String toString() {
    return "name: $name, value: $unit, unit: $unit";
  }

  static getIcon(String soicalName) {
    switch (soicalName) {
      case 'spotify':
        return FontAwesomeIcons.spotify;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'tiktok':
        return FontAwesomeIcons.tiktok;
      default:
        return FontAwesomeIcons.spotify;
    }
  }
}
