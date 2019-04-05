import 'package:http/http.dart';
class YouTubeApi {
    final String apiKey;
    YouTubeApi(this.apiKey);

    String _mapDurationToNamedCat(Duration duration){
        if (duration.inMinutes < 4){
            return "short";
        }
        else if (duration.inMinutes < 20){
            return "medium";
        }
        else {
            return "long";
        }
    }
}

class YouTubeSearch extends YouTubeApi {
    final String apiKey;
    final String query;
    List ignoreVideos = [];
    int maxQueries = 10;
    String _requestBase = "https://www.googleapis.com/youtube/v3/search?part=snippet";
    YouTubeSearch(this.apiKey,this.query,this.maxQueries) : super(apiKey){
        _requestBase = _requestBase + "&key=" + Uri.encodeComponent(apiKey);
    }

    YouTubeSingleResult searchByDuration(String query, Duration duration,bool preferOver){
        int queries = 0;
        Duration requestDuration = preferOver ? (Duration(minutes: (duration.inMinutes + 1))): duration;
        // What category the duration maps to (short,med,long,any)
        String durationCategory = this._mapDurationToNamedCat(requestDuration);
        // Construct query string
        String requestUrl = this._requestBase + "&videoDuration=" + durationCategory + "&q=" + Uri.encodeComponent(query);
    }
    
}


// Simple structs for return data
class YouTubeSingleResult {
    bool success = false;
    String videoUrl = "";
}