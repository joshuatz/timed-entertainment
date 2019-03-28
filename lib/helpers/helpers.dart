import 'dart:convert';

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