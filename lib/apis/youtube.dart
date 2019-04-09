import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timed_entertainment/helpers/helpers.dart';
class YouTubeApi {
    final String apiKey;
    bool mockMode;
    YouTubeApi(this.apiKey,[this.mockMode = false]);
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
    String _requestBase = YouTubeApi.requestBase + "videos?part=contentDetails";
    YouTubeDetails(this.apiKey) : super(apiKey){
        _requestBase = _requestBase + "&key=" + Uri.encodeComponent(apiKey);
    }
    
    Future<dynamic> videoDetailsJsonFromIds(List<String> videoIds) async {
        String requestUrl = this._requestBase + "&id=" + videoIds.join(",");
        print(requestUrl);
        var jsonResponse;
        if (!mockMode){
            var response = await http.get(requestUrl);
            jsonResponse = json.decode(response.body);
        }
        else {
            jsonResponse = await Helpers.localJson("lib/mockjson/yt-pagedetails-1.json");
        }
        return jsonResponse;
    }

    /// Takes the items array from a YT JSON response and appends stats and contentDetails to it by making another API call with IDs
    Future<List> appendContentDetailsToSearchResults(List videoItems) async {
        List<String> videoIds = videoItems.map<String>((item){
            return item['id']['videoId'];
        }).toList();
        var itemsWithDetailsBody;
        try {
            itemsWithDetailsBody = await this.videoDetailsJsonFromIds(videoIds);
        }
        catch (e){
            throw(e);
        }
        List itemsWithDetails = itemsWithDetailsBody['items'];
        return itemsWithDetails;
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
    String _mockBase = "lib/mockjson/";
    String _mockPath =  "";
    YouTubeSearch(this.apiKey,this.query,this.maxQueries,[bool mockMode = false]) : super(apiKey,mockMode){
        _requestBase = _requestBase + "&key=" + Uri.encodeComponent(apiKey) + "&type=video" + "&maxResults=50";
        _mockPath =  _mockBase + "yt-page-1.json";
    }

    /// @TODO - see if way to filter out live videos (0 duration returned by API, but would be nice to filter against initially)

    Future<YouTubeSingleResult> searchByDuration(Duration duration,bool preferOver,[var includeItems = const []]) async {
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
            _mockPath = this._mockBase + "yt-page-2.json";
        }

        // Actually making the request
        var response;
        print(requestUrl);
        if (_currQueries >= maxQueries){
            /// Immediately return
            String exception = "Max queries for search reached";
            print (exception);
            throw(Exception(exception));
        }
        else {
            _currQueries++;
            var jsonResponse;
            if (!mockMode){
                try {
                    response = await http.get(requestUrl);
                }
                catch (e){
                    throw(e);
                }
                jsonResponse = json.decode(response.body);
            }
            else {
                jsonResponse = await Helpers.localJson(this._mockPath);
            }

            /// Need to keep track of total results and pagination
            _totalResults = jsonResponse['pageInfo']['totalResults'];
            _nextPageToken = jsonResponse['nextPageToken'];
            _hasNextPage = (_nextPageToken != null);

            /// Actual results
            List items = jsonResponse['items'];

            /// YT does not include duration or stats in /search query, so need to append
            List itemsWithDuration = await YouTubeDetails(this.apiKey).appendContentDetailsToSearchResults(items);

            /// Make sure to include previous results in items list since YT does not return sorted by duration
            itemsWithDuration.addAll(includeItems);

            /// Filter list by duration
            try {
                /// If this is the last query we are going to make, set max variance to something bound to be satisfied - 10 minutes
                if (_currQueries >= maxQueries || !_hasNextPage){
                    print("Setting max variance to large amount to avoid not finding any video to play");
                    result = await filterListByDurationCriteria(itemsWithDuration, duration, preferOver, (60*10));
                }
                else {
                    result = await filterListByDurationCriteria(itemsWithDuration, duration, preferOver, (60));
                }
                
            }
            catch (e){
                /// Error was likely because no videos were found on list that are close to desired
                /// Try again
                if (_hasNextPage){
                    print("Filter list by duration did not return - trying again");
                    result = await searchByDuration(duration, preferOver,itemsWithDuration);
                }
                else {
                    throw(Exception("end of results reached!"));
                }
                
            }
            
            // finish Future
            return result;
        }
    }
    
    

    Future<YouTubeSingleResult> filterListByDurationCriteria(var items,Duration duration, bool preferOver, int maxVarianceInSec) async {
        YouTubeSingleResult result = new YouTubeSingleResult();
        // Original Items List
        // var items = jsonBody['items'];
        // List of filtered IDs to get more info on
        List filteredIds = List<String>();
        List filteredItems = List<dynamic>();
        // List of filtered items, sorted by variance from desired
        List itemsByVariance = List<dynamic>();

        print(items.length.toString());
        
        for (int x=0; x<items.length; x++){
            var item = items[x];
            bool blocker = false;
            Map t = {
                25 : "foobar"
            };
            String itemId = item['id'] is String ? item['id'] : item['id']['videoId'];
            // Check  if video ID is in list of already watched. Depending on which API endpoint list was generated from, ID can be in list as direct key pair or with nested id
            blocker = ignoreVideos.contains(itemId);
            if (!blocker){
                filteredIds.add(itemId);
                filteredItems.add(item);
            }
        }
        print(filteredItems.length.toString());

        for (int x=0; x<filteredItems.length; x++){
            var item = filteredItems[x];
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
        print("About to search list sorted by duration for map. Items count = " + itemsByVariance.length.toString());
        print("first on list = " + itemsByVariance.first.toString());
        print("last on list = " + itemsByVariance.last.toString());
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
            }
            else {
                // every single result on the list is over the max variance in seconds.
                print("No results from list were under max variance");
                throw(Exception("No results from list were under max variance"));
                break;
            }
        }
        /// If nothing was returned from loop, just return the one with the smallest variation, which should be first on sorted list
        return YouTubeSingleResult.fromDecodedJson(itemsByVariance.first);
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
        try {
            this.id = decodedJsonObj['id'];
            this.videoUrl = "https://www.youtube.com/watch?v=" + Uri.encodeComponent(this.id);
            this.rawInfo = decodedJsonObj;
            this.duration = YouTubeDetails.convertYtDurStringToDur(decodedJsonObj['contentDetails']['duration']);
            this.success = true;
        }
        catch (e){
            this.success = false;
        }
    }
}

class YouTubeHelpers extends YouTubeApi {
    final String apiKey;
    YouTubeHelpers(this.apiKey) : super(apiKey);

    static String generateEmbedUrl(String videoId){
        return "https://www.youtube-nocookie.com/embed/" + Uri.encodeComponent(videoId);
    }
}