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
}
