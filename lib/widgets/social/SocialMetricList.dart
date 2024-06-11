import 'package:flutter/material.dart';
import 'package:googleapis/container/v1.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/widgets/social/SocialMetricPill.dart';
import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/models/connections/spotify/spotify_signin_helper.dart';
import 'package:stay_indie/models/connections/yt_model.dart';

class SocialMetricList extends StatefulWidget {
  const SocialMetricList({
    required this.userId,
    super.key,
  });
  final String userId;
  @override
  State<SocialMetricList> createState() => _SocialMetricListState();
}

class _SocialMetricListState extends State<SocialMetricList> {
  late Future<SocialMetric?> spotify;
  late Future<SocialMetric?> yt_channel;
  @override
  void initState() {
    spotify = Spotify.getFromSupabaseResponse(widget.userId);
    yt_channel = Youtube.getFromSupabaseResponse(widget.userId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SocialMetric?>>(
      future: Future.wait([spotify, yt_channel]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('has data');
          print(snapshot.data.toString());

          return Container(
            margin: EdgeInsets.only(bottom: 10),
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
          print('Error: ' + snapshot.error.toString());
          return Container();
        }
        return Container();
      },
    );
  }
}
