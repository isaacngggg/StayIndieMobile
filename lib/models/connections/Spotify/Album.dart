import 'package:stay_indie/models/connections/Spotify/Spotify.dart';

class Album {
  String id;
  String title;
  List<String> artist;
  String year;
  String type;
  Uri imageUrl;
  String? genre;
  String? label;
  int? popularity;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.type,
    required this.imageUrl,
    this.genre,
    this.label,
    this.popularity,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    Spotify spotify = Spotify();
    return Album(
      id: json['id'],
      title: json['name'],
      artist: (json['artists'] as List)
          .map((item) => item['name'] as String)
          .toList(),
      year: json['release_date'],
      type: json['album_type'],
      imageUrl: Uri.parse(json['images'][0]['url']),
      popularity: json['popularity'],
    );
  }
}
