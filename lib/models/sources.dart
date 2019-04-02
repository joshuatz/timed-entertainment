import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum sourceEnum {
    YOUTUBE,
    LOCAL_FOLDER,
    INTERNET_RADIO_STREAM
}

enum YouTubeSourcesEnum {
    PUBLIC_PLAYLIST,
    PRIVATE_PLAYLIST,
    USER,
    TRENDING,
    SUBSCRIPTIONS,
    SEARCH_TERM
}
class SourceListItem {
    int enumIndex;
    String title;
    sourceEnum actualEnum;
    SourceListItem(this.enumIndex,this.title){
        this.actualEnum = sourceEnum.values[this.enumIndex];
    }

    static sourceEnum getEnumFromIndex(int sourceEnumIndex){
        return sourceEnum.values[sourceEnumIndex];
    }
}

// Needed for dropdown
List sourceTypeList = <SourceListItem>[
    SourceListItem(0,"YouTube"),
    SourceListItem(1,"Local Folder"),
    SourceListItem(2,"Internet Radio Stream")
];

class SourceMeta {
    sourceEnum source;
    // Generated
    String displayName;
    Icon icon;

    // Constructor
    SourceMeta(sourceEnum source){
        switch (source) {
            case sourceEnum.YOUTUBE : 
                this.displayName = 'YouTube';
                this.icon = Icon(FontAwesomeIcons.youtube);
                break;
            case sourceEnum.LOCAL_FOLDER :
                this.displayName = 'Local Folder';
                this.icon = Icon(Icons.folder);
                break;
            case sourceEnum.INTERNET_RADIO_STREAM :
                this.displayName = 'Internet Radio';
                this.icon = Icon(Icons.radio);
                break;
            default:
        }
    }
}

class BaseSourceConfig {
    int configId;
    sourceEnum sourceType = sourceEnum.YOUTUBE;
    bool hasUserDefinedName;
    String userDefinedName;
    String searchTerm;
    bool allowRepeats;
    bool neverAllowRepeats;
    Duration minElapsedBeforeRepeat;
    YouTubeSourcesEnum youtubeSrc = YouTubeSourcesEnum.SEARCH_TERM;
    
    Map<String,dynamic> toJson() => {
        "id" : this.configId,
        "sourceType" : this.sourceType.index,
        "hasUserDefinedName" : this.hasUserDefinedName,
        "userDefinedName" : this.userDefinedName,
        "searchTerm" : this.searchTerm,
        "allowRepeats" : this.allowRepeats,
        "neverAllowRepeats" : this.neverAllowRepeats,
        "minElapsedBeforeRepeat" : this.minElapsedBeforeRepeat.inMicroseconds
    };
    

    // Constructor(s)
    BaseSourceConfig.mock(this.configId,this.sourceType);
    BaseSourceConfig();
}


class YoutubeSourceConfig extends BaseSourceConfig {
    YouTubeSourcesEnum youtubeSrc;
    @override
    Map<String,dynamic> toJson(){
        // Get map from base config
        var configMap = super.toJson();
        // Now append youtube specific params
        configMap["youtubeSrc"] = this.youtubeSrc.index;
        // Return mapped
        return configMap;
    }
    // Constructor
    // YoutubeSourceConfig() : super(configId,sourceType);
}