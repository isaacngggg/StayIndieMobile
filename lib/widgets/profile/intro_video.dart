import 'package:flutter/material.dart';

import 'package:youtube_shorts/youtube_shorts.dart';

class IntroVideo extends StatefulWidget {
  const IntroVideo({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<IntroVideo> createState() => _IntroVideoState();
}

class _IntroVideoState extends State<IntroVideo> {
  late final ShortsController shortsController;

  @override
  void initState() {
    // TODO: implement initState
    shortsController = ShortsController(
      startVideoMuted: true,
      youtubeVideoSourceController: VideosSourceController.fromUrlList(
        videoIds: [
          widget.videoUrl,
        ],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 1.778,
      child: YoutubeShortsPage(
        initialVolume: 0,
        controller: shortsController,
        loadingWidget: null,
      ),
    );
  }
}
