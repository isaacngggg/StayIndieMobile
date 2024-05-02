import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';

class YoutubeAccount {
  String id;
  String name;
  String channelUrl;
  String imageUrl;
  int subscriberCount;
  int videoCount;

  YoutubeAccount({
    required this.id,
    required this.name,
    required this.channelUrl,
    required this.imageUrl,
    required this.subscriberCount,
    required this.videoCount,
  });

  YoutubeAccount.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        channelUrl = map['channel_url'],
        imageUrl = map['image_url'],
        subscriberCount = map['subscriber_count'],
        videoCount = map['video_count'];
}

class Youtube {
  final authorizationEndpoint =
      Uri.parse('https://accounts.google.com/o/oauth2/v2/auth');
  final tokenEndpoint = Uri.parse('https://oauth2.googleapis.com/token');
  final redirectUrl = Uri.parse('http://localhost:8080/callback');
  final identifier = 'my client identifier';
  final secret = 'my client secret';

  Future<oauth2.Client> getClient() async {
    var grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
    );

    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
        scopes: ['https://www.googleapis.com/auth/youtube.readonly']);

    // Redirect the user to the authorization URL. This will be specific to your platform.
    // For example, you might open a webview or redirect the user to their browser and then listen for a redirect back to your application.

    // Once you've redirected the user and they've authorized your application, they'll be redirected back to your application with an authorization code in the query parameters.

    // You can then exchange this authorization code for an access token:

    var responseUrl =
        await listenForResponse(); // Implement this function to listen for the redirect with the authorization code.

    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  Future<Uri> listenForResponse() async {
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    var request = await server.first;
    var responseUrl = request.uri;
    request.response
      ..statusCode = 200
      ..headers.set('Content-Type', ContentType.html.mimeType)
      ..write('<html><h1>You can now close this window</h1></html>');
    await request.response.close();
    await server.close();
    return responseUrl;
  }
}
