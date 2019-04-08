import 'package:http/http.dart' as http;
import 'dart:convert';
class YouTubeApi {
    final String apiKey;
    YouTubeApi(this.apiKey);
    static String requestBase = "https://www.googleapis.com/youtube/v3/";

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

class YouTubeDetails extends YouTubeApi {
    final String apiKey;
    String _requestBase = YouTubeApi.requestBase + "videos?part=snippet,contentDetails,statistics";
    YouTubeDetails(this.apiKey) : super(apiKey){
        _requestBase = _requestBase + "&key=" + Uri.encodeComponent(apiKey);
    }
    
    Future<dynamic> videoDetailsFromIds(List<String> videoIds) async {
        String requestUrl = this._requestBase + "&id=" + videoIds.join(",");
        var response = await http.get(requestUrl);
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
    }

    static Duration convertYtDurStringToDur(String ytDurString){
        int days = 0;
        int hours = 0;
        int minutes = 0;
        int seconds = 0;
        RegExp daysReg = new RegExp(r"(\d+)D");
        RegExp hoursReg = new RegExp(r"(\d+)H");
        RegExp minutesReg = new RegExp(r"(\d+)M");
        RegExp secondsReg = new RegExp(r"(\d+)S");
        // Example input: "PT1H36M1S" for 1 Hour, 36 Minutes, 1 Second. Or "PT2M44S" for 2 Minutes, 44 Seconds. Or "PT10H" for exactly 10 hours. Or "P1DT1S" for 1 day and 1 second.
        days = daysReg.hasMatch(ytDurString) ? int.parse(daysReg.allMatches(ytDurString).first.group(1)) : days;
        hours = hoursReg.hasMatch(ytDurString) ? int.parse(hoursReg.allMatches(ytDurString).first.group(1)) : hours;
        minutes = minutesReg.hasMatch(ytDurString) ? int.parse(minutesReg.allMatches(ytDurString).first.group(1)) : minutes;
        seconds = secondsReg.hasMatch(ytDurString) ? int.parse(secondsReg.allMatches(ytDurString).first.group(1)) : seconds;
        return Duration(
            days: days,
            hours: hours,
            minutes: minutes,
            seconds: seconds
        );
    }
}

class YouTubeSearch extends YouTubeApi {
    /// Pagination
    int _totalResults = 0;
    int _currPage = 1;
    String _nextPageToken = "";
    bool _hasNextPage = false;

    final String apiKey;
    final String query;
    List ignoreVideos = [];
    int maxQueries = 10;
    int _currQueries = 0;
    String _requestBase = YouTubeApi.requestBase + "search?part=snippet";
    YouTubeSearch(this.apiKey,this.query,this.maxQueries) : super(apiKey){
        _requestBase = _requestBase + "&key=" + Uri.encodeComponent(apiKey) + "&type=video" + "&maxResults=50";
    }

    Future<YouTubeSingleResult> searchByDuration(Duration duration,bool preferOver) async {
        print("Page # = " + _currPage.toString() + " || curr queries = " + _currQueries.toString() + " || max queries = " + maxQueries.toString());
        YouTubeSingleResult result = YouTubeSingleResult();
        Duration requestDuration = preferOver ? (Duration(minutes: (duration.inMinutes + 1))): duration;
        /// What category the duration maps to (short,med,long,any)
        String durationCategory = this._mapDurationToNamedCat(requestDuration);
        /// Construct query string
        String requestUrl = _requestBase + "&videoDuration=" + durationCategory + "&q=" + Uri.encodeComponent(query);

        /// If we are currently paginating (past first page) need to append to querystring with paging data
        if (_hasNextPage){
            _currPage++;
            requestUrl += "&pageToken=" + Uri.encodeComponent(_nextPageToken);
        }



        // Actually making the request
        var response;
        print(requestUrl);
        if (_currQueries >= maxQueries){
            /// Immediately return
            String exception = "Max queries for search reeached";
            print (exception);
            throw(Exception(exception));
        }
        else {
            _currQueries++;

            try {
                response = await http.get(requestUrl);
            }
            catch (e){
                throw(e);
            }
            var jsonResponse = json.decode(response.body);

            /// Need to keep track of total results and pagination
            _totalResults = jsonResponse['pageInfo']['totalResults'];
            _nextPageToken = jsonResponse['nextPageToken'];
            _hasNextPage = (_nextPageToken != null);

            /// Filter list by duration
            /// @TODO handle paging of data and use of maxQueries to limit
            try {
                /// If this is the last query we are going to make, set max variance to something bound to be satisfied - 10 minutes
                if (_currQueries >= maxQueries || !_hasNextPage){
                    print("Setting max variance to large amount to avoid not finding any video to play");
                    result = await filterListByDurationCriteria(jsonResponse, duration, preferOver, (60*10));
                }
                else {
                    result = await filterListByDurationCriteria(jsonResponse, duration, preferOver, (60));
                }
                
            }
            catch (e){
                /// Error was likely because no videos were found on list that are close to desired
                /// Try again
                if (_hasNextPage){
                    print("Filter list by duration did not return - trying again");
                    result = await searchByDuration(duration, preferOver);
                }
                else {
                    throw(Exception("end of results reached!"));
                }
                
            }
            
            // finish Future
            return result;
        }
    }
    
    

    Future<YouTubeSingleResult> filterListByDurationCriteria(var jsonBody,Duration duration, bool preferOver, int maxVarianceInSec) async {
        YouTubeSingleResult result = new YouTubeSingleResult();
        // Original Items List
        var items = jsonBody['items'];
        // List of filtered IDs to get more info on
        List filteredIds = List<String>();
        // List of filtered items, sorted by variance from desired
        List itemsByVariance = List<dynamic>();
        
        for (int x=0; x<items.length; x++){
            var item = items[x];
            bool blocker = false;
            // Check  if video ID is in list of already watched
            blocker = ignoreVideos.contains(item['id']['videoId']);
            if (!blocker){
                filteredIds.add(item['id']['videoId']);
            }
        }

        // Now, make another API call to get the details on these specific videos
        var itemsWithDetailsBody = await YouTubeDetails(this.apiKey).videoDetailsFromIds(filteredIds);
        var itemsWithDetails = itemsWithDetailsBody['items'];
        // Iterate through items and extract duration
        for (int x=0; x<itemsWithDetails.length; x++){
            var item = itemsWithDetails[x];
            Duration itemDuration = YouTubeDetails.convertYtDurStringToDur(item['contentDetails']['duration']);
            // Variance will be positive if vid is less than desired, negative if longer
            int varianceInSec = duration.inSeconds - itemDuration.inSeconds;
            item['duration'] = itemDuration;
            item['varianceInSec'] = varianceInSec;
            item['varianceDirection'] = varianceInSec >= 0 ? 'under' : 'over';
            item['absVarianceInSec'] = varianceInSec.abs();
            itemsByVariance.add(item);
        }
        print(itemsByVariance.length.toString());
        // Sort list by variance from desired duration
        itemsByVariance.sort((itemA,itemB){
            return itemA['absVarianceInSec'].compareTo(itemB['absVarianceInSec']);
        });

        // Finally, loop through filtered, sorted list, and return first result that is closest to desired duration and pref for over vs under
        for (int x=0; x<itemsByVariance.length; x++){
            var item = itemsByVariance[x];
            if (item['absVarianceInSec'] <= maxVarianceInSec){
                if (preferOver && item['varianceDirection'] =='over'){
                    print("VIDEO FOUND");
                    return YouTubeSingleResult.fromDecodedJson(item);
                }
                else if (!preferOver && item['varianceDirection'] == 'under'){
                    print("VIDEO FOUND");
                    return YouTubeSingleResult.fromDecodedJson(item);
                }
                else if (x == itemsByVariance.length - 1){
                    // Last result, but no matches so far
                }
            }
            else {
                // every single result on the list is over the max variance in seconds.
                print("No results from list were under max variance");
                throw(Exception("No results from list were under max variance"));
                break;
            }
        }
        return result;
    }
}


// Simple structs for return data
// @TODO move to models?
class YouTubeSingleResult {
    bool success = false;
    String videoUrl = "";
    String id = "";
    var rawInfo = json.decode("{}");
    Duration duration;

    YouTubeSingleResult();
    // JSON constructor
    YouTubeSingleResult.fromDecodedJson(var decodedJsonObj){
        this.id = decodedJsonObj['id'];
        this.videoUrl = "https://www.youtube.com/watch?v=" + Uri.encodeComponent(this.id);
        this.rawInfo = decodedJsonObj;
        this.duration = YouTubeDetails.convertYtDurStringToDur(decodedJsonObj['contentDetails']['duration']);
    }
}

class YouTubeHelpers extends YouTubeApi {
    final String apiKey;
    YouTubeHelpers(this.apiKey) : super(apiKey);

    static String generateEmbedUrl(String videoId){
        return "https://www.youtube-nocookie.com/embed/" + Uri.encodeComponent(videoId);
    }
}