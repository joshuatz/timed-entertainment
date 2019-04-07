import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/ui/components/video_webview.dart';
import 'package:timed_entertainment/apis/youtube.dart';
import 'package:youtube_player/youtube_player.dart';

class PlayerPage extends StatefulWidget {
    final sourceEnum source;
    final Duration timerDuration;
    YouTubeSingleResult youtubeVideo;
    PlayerPage({Key key, @required this.timerDuration, @required this.source, this.youtubeVideo});

    @override
    _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text("Video Player"),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                child: buildPlayerInner(),
            ),
        );
    }

    Widget buildPlayerInner(){
        if (widget.source == sourceEnum.YOUTUBE){
            // return VideoWebview(
            //     videoUrl: YouTubeHelpers.generateEmbedUrl(widget.youtubeVideo.id),
            // );
            return YoutubePlayer(
                context: context,
                source: widget.youtubeVideo.id,
                quality: YoutubeQuality.MEDIUM,
                autoPlay: true,
                startFullScreen: true,
            );
        }
    }
}