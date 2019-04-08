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

    static String timeTextFromDuration(Duration dur){
        String result = "";
        int totalSeconds = dur.inSeconds;
        int hours = 0;
        int minutes = 0;
        int seconds = 0;
        int remainder = totalSeconds;
        // Calc hours
        if (totalSeconds >= (60*60)){
            hours = (totalSeconds / (60*60)).floor();
            remainder = totalSeconds % (60*60);
        }
        // Calc minutes
        if (remainder >= 60){
            minutes = (remainder / 60).floor();
            remainder = remainder % 60;
        }
        // calc seconds
        if (remainder >= 0){
            seconds = remainder;
        }
        
        // Only include hours in output string if non-zero
        if (hours > 0){
            result += hours.toString().padLeft(2,"0") + ":";
        }
        result += minutes.toString().padLeft(2,"0") + ":" + seconds.toString().padLeft(2,"0");
        print("Time to String: " + result);
        return result;
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