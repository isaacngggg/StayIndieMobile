import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class ConnectSocialPage extends StatelessWidget {
  static const id = '/connect_social_page';
  final fb = FacebookLogin();

  Future<void> _loginWithFacebook() async {
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        print('Access token: ${accessToken?.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect your socials'),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                    onPressed: () {
                      _loginWithFacebook();
                    },
                    child: Text('Connect Facebook'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: Text('Connect YouTube'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white)),
                TextButton(
                    onPressed: () {},
                    child: Text('Connect Instagram'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white)),
                TextButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                  title: const Text('Flutter Simple Example')),
                              body: WebViewWidget(controller: controller),
                            ),
                          ));
                    },
                    child: Text('Connect Spotify'),
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black)),
              ],
            )),
      ),
    );
  }
}
