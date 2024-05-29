class yt_channel {
  final String? id;
  final String? name;
  final String? description;

  yt_channel({this.id, this.name, this.description});

  factory yt_channel.fromMap(Map<String, dynamic> json) {
    return yt_channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
