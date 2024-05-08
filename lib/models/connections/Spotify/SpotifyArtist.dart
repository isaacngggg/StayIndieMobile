class SpotifyArtist {
  String id;
  String name;
  List<String>? imageUrls = [];
  String spotifyUri;
  List<String>? genres = [];
  int popularity;
  int? followers;

  SpotifyArtist({
    required this.id,
    required this.name,
    this.imageUrls,
    required this.spotifyUri,
    this.genres,
    required this.popularity,
    this.followers,
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    return SpotifyArtist(
      id: json['id'],
      name: json['name'],
      imageUrls: json['images'] != null
          ? List<String>.from(json['images'].map((image) => image['url']))
          : [],
      spotifyUri: json['uri'],
      genres: List<String>.from(json['genres']),
      popularity: json['popularity'],
      followers: json['followers'] != null ? json['followers']['total'] : null,
    );
  }
}
