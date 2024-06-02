import 'dart:convert';
import 'package:http/http.dart' as http;

class SoundCloudAPI {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  SoundCloudAPI({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  // Step 1: Get authorization URL
  String getAuthorizationUrl() {
    return 'https://soundcloud.com/connect?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=non-expiring';
  }

  // Step 2: Exchange authorization code for access token
  Future<String> getAccessToken(String authorizationCode) async {
    final response = await http.post(
      Uri.parse('https://api.soundcloud.com/oauth2/token'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
        'code': authorizationCode,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  // Step 3: Get user profile ID
  Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.soundcloud.com/me'),
      headers: {
        'Authorization': 'OAuth $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  // Step 4: Get user tracks/projects
  Future<List<dynamic>> getUserTracks(String accessToken, String userId) async {
    final response = await http.get(
      Uri.parse('https://api.soundcloud.com/users/$userId/tracks'),
      headers: {
        'Authorization': 'OAuth $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user tracks');
    }
  }
}
