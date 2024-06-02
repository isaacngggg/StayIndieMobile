import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/social/SocialMetricPill.dart';
import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/models/connections/spotify/spotify_signin_helper.dart';

class SocialMetricList extends StatefulWidget {
  const SocialMetricList({
    super.key,
    required this.socialMetrics,
  });

  final List socialMetrics;

  @override
  State<SocialMetricList> createState() => _SocialMetricListState();
}

class _SocialMetricListState extends State<SocialMetricList> {
  Future<SocialMetric?> spotify =
      Spotify.getSpotifyMetricFromSupabase(currentUserId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SocialMetric?>>(
      future: Future.wait([spotify]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 36,
            child: ListView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: [
                for (var socialMetric in snapshot.data!) ...[
                  socialMetric != null
                      ? SocialMetricPill(socialMetric: socialMetric)
                      : Container(),
                ]
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
