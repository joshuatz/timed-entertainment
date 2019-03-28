import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum sourceEnum {
    YOUTUBE,
    LOCAL_FOLDER,
    INTERNET_RADIO_STREAM
}

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
    sourceEnum sourceType;
    bool hasUserDefinedName;
    String userDefinedName;
    String searchTerm;
    bool allowRepeats;
    bool neverAllowRepeats;
    Duration minElapsedBeforeRepeat;
    
    Map<String,dynamic> toJson() => {
        "id" : this.configId
    };
    

    // Constructor
    BaseSourceConfig.mock(this.configId,this.sourceType);
    BaseSourceConfig();
}

enum YouTubeSourcesEnum {
    PLAYLIST,
    USER,
    TRENDING,
    SUBSCRIPTIONS
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