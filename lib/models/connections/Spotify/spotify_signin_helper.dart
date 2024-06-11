import 'dart:math';

import 'package:spotify/spotify.dart';

import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/SocialMetric.dart';

class Spotify {
  final String _clientID = '73b95bad8e0d41189fe36b60b8e514e7';
  final String _clientSecret = '35e587aca4f242eebbe9a1d99d408822';

  init() async {
    var credentials = SpotifyApiCredentials(_clientID, _clientSecret);
    var spotify = SpotifyApi(credentials);
    return spotify;
  }

  Future<List<Artist>> searchArtist(String query) async {
    List<Artist> searchResult = [];
    SpotifyApi spotify = await init();
    print('searching for artist');
    BundledPages resultsPages =
        spotify.search.get(query, types: [SearchType.artist]);
    var page = await resultsPages.getPage(5);

    for (var artist in page) {
      artist.items?.forEach((item) {
        searchResult.add(item as Artist);
      });
    }
    return searchResult;
  }

  static Future addArtistToDatabase(Artist artist) async {
    await supabase.from('spotify_profiles').upsert({
      'id': artist.id,
      'name': artist.name,
      'image_url': artist.images?.first.url,
      'popularity': artist.popularity,
      'followers': artist.followers?.total,
    });
  }

  static Future<SocialMetric?> getFromSupabaseResponse(String id) async {
    final response = await supabase
        .from('spotify_profiles')
        .select()
        .eq('user_id', id)
        .single();

    if (response.isNotEmpty) {
      print('spotify response: not empty');
      return SocialMetric(
        name: 'spotify',
        value: formatLargeNumber(response['followers']).toString(),
        unit: 'followers',
      );
    } else {
      print('spotify response: nothing found');
      return null;
    }
  }
}
