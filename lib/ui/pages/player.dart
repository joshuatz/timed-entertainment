import 'package:flutter/material.dart';
import 'package:timed_entertainment/ui/components/video_webview.dart';

class PlayerPage extends StatefulWidget {
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
                child: VideoWebview(
                    videoUrl: "https://www.youtube.com/watch?v=GrVNwqbH0kA",
                ),
            ),
        )
    }
}