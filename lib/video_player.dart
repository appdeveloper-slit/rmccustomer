import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'toolbar/toolbar.dart';
import 'values/colors.dart';

class VideoPlayer extends StatefulWidget {
  final Map<String, dynamic> data;

  const VideoPlayer(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerPage();
  }
}

class VideoPlayerPage extends State<VideoPlayer> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  late YoutubePlayerController playerController;
  String? sLink;

  @override
  void initState() {
    v = widget.data;
    if (v['link'].contains('youtu.be')) {
      sLink = v['link'].toString().replaceAll('https://youtu.be/', '');
    } else {
      sLink = v['link']
          .toString()
          .replaceAll('https://www.youtube.com/watch?v=', '');
    }
    playerController = YoutubePlayerController.fromVideoId(
      videoId: sLink!,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, v['name']),
      body: Center(
        child: YoutubePlayer(
          controller: playerController,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
