class Track {
  String id;
  String name;
  List<String> artist;
  String year;
  Uri link;
  Uri previewUrl;
  Uri imageUrl;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.year,
    required this.link,
    required this.previewUrl,
    required this.imageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      name: json['name'],
      artist: (json['artists'] as List)
          .map((item) => item['name'] as String)
          .toList(),
      year: DateTime.parse(json['album']['release_date']).year.toString(),
      link: Uri.parse(json['external_urls']['spotify']),
      previewUrl: Uri.parse(json['preview_url']),
      imageUrl: Uri.parse(json['album']['images'][0]['url']),
    );
  }
}
