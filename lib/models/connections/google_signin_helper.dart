import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:stay_indie/constants.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [YouTubeApi.youtubeReadonlyScope],
  );
  GoogleSignInAccount? account = null;
  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
      // After successful sign-in, you can fetch the channel ID if needed:
      account = _googleSignIn.currentUser;

      AuthClient? client = await _googleSignIn.authenticatedClient();
      print(account?.displayName ?? "No user");
      if (client != null) {
        final Channel? channel = await fetchYoutubeChannel(client);

        print('Channel ID: ${channel?.id}');
        print('Channel Title: ${channel?.snippet?.title}');
        print('Channel Description: ${channel?.snippet?.description}');
        // Handle the channelId
        if (channel != null) {
          await addChannelToDatabase(channel);
        }
      }
    } catch (error) {
      // Handle sign-in errors
      print('Sign-in error: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('Sign-out successful');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<Channel?> fetchYoutubeChannel(AuthClient client) async {
    try {
      print('authHeaderssjdposa');
      try {
        final youtubeApi = YouTubeApi(client);
        final channelsResponse = await youtubeApi.channels
            .list(['id', 'snippet', 'statistics'], mine: true);

        // Check if channelsResponse is valid before proceeding
        if (channelsResponse.items == null || channelsResponse.items!.isEmpty) {
          throw Exception('No YouTube channels found for this account');
        }
        return channelsResponse.items!.first;
      } catch (e) {
        print('Error creating authenticated client: $e');
      }
    } on DetailedApiRequestError catch (e) {
      // Handle YouTube API errors (e.g., quota exceeded)
      print('YouTube API Error: ${e.message}');
    } catch (e) {
      print('Error fetching YouTube channel ID: $e');
    }
    return null;
  }

  Future<void> addChannelToDatabase(Channel channel) async {
    // Add the channel ID to your database
    await supabase.from('yt_channels').upsert({
      'id': channel.id,
      'name': channel.snippet?.title,
      'description': channel.snippet?.description,
      'subscriber_count': channel.statistics?.subscriberCount,
      'imageUrl': channel.snippet?.thumbnails?.default_?.url ?? '',
    }).eq('channel_id', channel.id!);
  }
}
