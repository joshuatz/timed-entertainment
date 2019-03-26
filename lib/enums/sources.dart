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

class SourceConfigMapping {
    int id;
    sourceEnum source;
    SourceConfigMapping(this.id,this.source);
}

class BaseSourceConfig {
    int id;
    bool hasUserDefinedName;
    String userDefinedName;
    bool allowRepeats;
    bool neverAllowRepeats;
    Duration minElapsedBeforeRepeat;
    BaseSourceConfig(this.id,this.hasUserDefinedName);
}