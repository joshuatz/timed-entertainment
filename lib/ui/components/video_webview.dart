import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoWebview extends StatelessWidget {
    final String videoUrl;

    VideoWebview({Key key,@required this.videoUrl}) : super(key:key);

    @override
    Widget build(BuildContext context){
        return WebView(
            initialUrl: this.videoUrl,
            javascriptMode: JavascriptMode.unrestricted,
        );
    }
}