import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/ui/components/video_webview.dart';
import 'package:timed_entertainment/apis/youtube.dart';
import 'package:youtube_player/youtube_player.dart';
import 'dart:async';
import 'package:timed_entertainment/helpers/helpers.dart';

class PlayerPage extends StatefulWidget {
    final sourceEnum source;
    final Duration timerDuration;
    YouTubeSingleResult youtubeVideo;
    PlayerPage({Key key, @required this.timerDuration, @required this.source, this.youtubeVideo});

    @override
    _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
    int _currElapsedTimeSec = 0;
    int _timeLeftSec = 0;
    Timer _playerTimer;
    VideoPlayerController _controller;
    bool _timerStarted = false;

    void handleStartPlay(){
        _timeLeftSec = widget.timerDuration.inSeconds;
        // Initialize and start timer
        // Make sure to specific duration as const not inline!
        const Duration _timerDur = const Duration(seconds: 1);
        _timerStarted = true;
        _playerTimer = new Timer.periodic(_timerDur, (Timer timer){
            this.setState((){
                int elapsedTime = _currElapsedTimeSec + 1;
                _currElapsedTimeSec = elapsedTime;
                _timeLeftSec = widget.timerDuration.inSeconds - elapsedTime;
                print("Elapsed = " + elapsedTime.toString() + " || Time left = " + _timeLeftSec.toString());
            });
        });
    }

    @override
    Widget build(BuildContext context){
        // Start the timer and anything else needed when vid starts playing
        if (_timerStarted == false){
            handleStartPlay();
        }

        return Scaffold(
            appBar: AppBar(
                title: Text("Video Player"),
            ),
            body: Stack(
                children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: buildPlayerInner(),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(Helpers.timeTextFromDuration(Duration(seconds: _timeLeftSec))),
                    ),
                ],
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
                playerMode: YoutubePlayerMode.NO_CONTROLS,
                callbackController: (controller){
                    _controller = controller;
                },
            );
        }
    }

    @override
    void dispose(){
        _playerTimer.cancel();
        _controller.pause();
        // @TODO save play state of video, with remaining time, etc.
        super.dispose();
    }
}