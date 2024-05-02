import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SpotifyArtist.dart';
import 'Album.dart';
import 'Track.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class Spotify {
  final String _clientID = '73b95bad8e0d41189fe36b60b8e514e7';
  final String _clientSecret = '35e587aca4f242eebbe9a1d99d408822';
  final String _baseAuthUrl = 'https://accounts.spotify.com/api/token';
  final String _baseUrl = 'https://api.spotify.com/v1/';

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse(_baseAuthUrl),
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$_clientID:$_clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  Future<Map<String, dynamic>> searchArtist(String query) async {
    String endpoint = 'search';
    String accessToken = await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint?q=$query&type=artist'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<List<Album>> getArtistAlbums(String artistId) async {
    String endpoint = 'artists/$artistId/albums';
    String accessToken = await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<Album> albums = [];
      for (var album in jsonDecode(response.body)['items']) {
        albums.add(Album.fromJson(album));
      }
      return albums;
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<Album> getAlbum(String albumId) async {
    String endpoint = 'albums/$albumId';
    String accessToken = await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }

  Future<Track> getTopTracks(String artistId) async {
    String endpoint = 'artists/$artistId/top-tracks';
    String accessToken = await _getAccessToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return Track.fromJson(jsonDecode(response.body)['tracks'][0]);
    } else {
      throw Exception('Failed to load data: ${response.body}');
    }
  }
}

void main() async {
  print('Spotify API');
  Spotify spotify = Spotify();
  // spotify.searchArtist('Ariana Grande').then((data) {
  //   for (var artist in data['artists']['items']) {
  //     SpotifyArtist newArtist = SpotifyArtist.fromJson(artist);
  //     print("Artist name retrieved: " + newArtist.name);
  //     print("Artist genres retrieved: " + newArtist.genres.toString());
  //     print(newArtist.imageUrls.toString());
  //     print("Artist followers: ${newArtist.followers}");
  //   }
  // });

  spotify.getArtistAlbums('2sSGPbdZJkaSE2AbcGOACx').then((albums) {
    for (var album in albums) {
      print(album.title);
    }
  });

  spotify.getTopTracks('2sSGPbdZJkaSE2AbcGOACx').then((track) {
    print('top track:');
    print(track.name);
  });
}
