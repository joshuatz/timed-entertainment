import 'dart:convert';
import 'package:flutter/material.dart';
class Helpers {
    static String serializeDuration(Duration dur){
        var unserializedDurObj = {
            'days': dur.inDays,
            'hours': dur.inHours,
            'minutes': dur.inMinutes,
            'seconds': dur.inSeconds,
            'milliseconds': dur.inMilliseconds,
            'microseconds': dur.inMicroseconds
        };
        String serializedDur = jsonEncode(unserializedDurObj);
        return serializedDur;
    }

    static Duration deserializeDuration(String dur){
        var parsedDurObj = jsonDecode(dur);
        Duration parsedDurFinal = Duration(
            days: parsedDurObj["days"],
            hours: parsedDurObj["hours,"],
            minutes: parsedDurObj["minutes,"],
            seconds: parsedDurObj["seconds,"],
            milliseconds: parsedDurObj["milliseconds,"],
            microseconds: parsedDurObj["microseconds"]
        );
        return parsedDurFinal;
    }
}

class StdSnackBar extends SnackBar {
    final text;
    Duration duration;
    final bool dismissable;
    BuildContext context;
    StdSnackBar({Key key,@required this.text,this.duration = const Duration(seconds: 2),@required this.dismissable,this.context}) : super(
        key : key,
        content : Text(text),
        duration : duration,
        action : !dismissable ? null : SnackBarAction(
            label: "Dismiss",
            onPressed: (){
                Scaffold.of(context).hideCurrentSnackBar();
            },
        )
    );
}