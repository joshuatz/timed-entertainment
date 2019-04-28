import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';

// enum WatchedVidConfigStatus {
    
// }

class WatchedVidConfig {
    String videoId;

    // Watching status
    bool completed = false; // Has the video ever been completely watched through?
    int watchCount = 0; //  How many times has the video been COMPLETELY watched through
    bool inProgress = false; // If the video was left in a partially watched state.
    int lastWatchCompletedOn; // Epoch stamp of when the vid was last watched completely
    Duration pausedAt; // If inProgress is true, and the video was interrupted, this should be a duration less than the length of the video itself

    // Meta info about the video to cache
    Duration length;
    sourceEnum source = sourceEnum.YOUTUBE;

    static WatchedVidConfig mock(){
        var _instance = WatchedVidConfig();
        _instance.videoId = "Cf1KgYF8pJU";
        _instance.completed = true;
        return _instance;
    }

    Map<String,dynamic> toJson(){
        Map<String,dynamic> jsonMap = {
            "videoId" : this.videoId,
            "completed" : this.completed,
            "watchCount" : this.watchCount,
            "inProgress" : this.inProgress,
            "lastWatchCompletedOn" : this.lastWatchCompletedOn,
            "pausedAt" : this.pausedAt?.inMicroseconds,
            "length" : this.length?.inMicroseconds
        };
        return jsonMap;
    }

    WatchedVidConfig fromJson(Map<String,dynamic> jsonMap){
        WatchedVidConfig parsedConfig = new WatchedVidConfig();
        // @TODO
        return parsedConfig;
    }
}

class WatchedVidsBloc extends Bloc<WatchedVidConfig,Map>{
    // Singleton
    static final WatchedVidsBloc _instance = new WatchedVidsBloc._internal();
    factory WatchedVidsBloc(){
        return _instance;
    }
    WatchedVidsBloc._internal();

    static const String _storageKey = "watchedVidsMap";

    void loadFromStorage(){
        // @TODO
    }
    void saveToStorage(){
        //@TODO
    }

    @override
    Map<String,WatchedVidConfig> get initialState {
        // @TODO
        var _mockConfig = WatchedVidConfig.mock();
        var fakeMap = {
            (_mockConfig.videoId) : _mockConfig
        };
        return fakeMap;
    }

    @override
    Stream<Map<String,WatchedVidConfig>> mapEventToState(WatchedVidConfig event) async*{
        var _updatedState = Map<String,WatchedVidConfig>.from(currentState);

        // @TODO

        yield _updatedState;
    }

    @override
    void dispose(){
        super.dispose();
    }


    List<String> getCompletedVidIds(){
        List<String> completedVidIds = List<String>();
        currentState.forEach((dynamic id, dynamic config){
            if (config.completed && config.inProgress == false){
                completedVidIds.add(id);
            }
        });
        return completedVidIds;
    }

    bool checkIfVidInProgress(String videoId){
        return currentState[videoId].inProgress;
    }

    Duration getPausedAtSpot(String videoId){
        return currentState[videoId].pausedAt;
    }
}