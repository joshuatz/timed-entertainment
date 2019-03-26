import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum sourceEnum {
    YOUTUBE,
    LOCAL_FOLDER
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
            default:
        }
    }
}