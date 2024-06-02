import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'soundcloud_api.dart';

class SoundCloudLogin extends StatefulWidget {
  @override
  _SoundCloudLoginState createState() => _SoundCloudLoginState();
}

class _SoundCloudLoginState extends State<SoundCloudLogin> {
  final String clientId = 'Qye966U2UxCyRCEwCdB4dJ5lXs9uJeqZ';
  final String clientSecret = '0OpUroQPixttleuw9FrFmCaB2HTfanvf';
  final String redirectUri = 'app.thegreenroomapp://soundcloud-callback';

  late SoundCloudAPI soundCloudAPI;

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    soundCloudAPI = SoundCloudAPI(
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar, if necessary.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith(redirectUri)) {
              final Uri uri = Uri.parse(request.url);
              final String? code = uri.queryParameters['code'];

              if (code != null) {
                // Step 2: Exchange authorization code for access token
                String accessToken = await soundCloudAPI.getAccessToken(code);

                // Step 3: Get user profile
                Map<String, dynamic> profile =
                    await soundCloudAPI.getUserProfile(accessToken);
                print('User Profile: $profile');

                // Step 4: Get user tracks/projects
                List<dynamic> tracks = await soundCloudAPI.getUserTracks(
                    accessToken, profile['id'].toString());
                print('User Tracks: $tracks');

                Navigator.pop(context); // Close the WebView after login
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
