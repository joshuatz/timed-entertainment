import 'package:flutter/material.dart';


class GlobalSettingsHelpModal extends StatelessWidget {
    @override
    Widget build(BuildContext context){
        return Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            child: SimpleDialog(
                elevation: 20,
                contentPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                title: Text("About Global Settings"),
                children: <Widget>[
                    FutureBuilder(
                        future: DefaultAssetBundle.of(context).loadString("assets/Settings_Help_Page.txt"),
                        builder: (context,snapshot){
                            return new Text(snapshot.data ?? 'Sorry, unable to load help file!', softWrap: true);
                        },
                    ),
                ],
            ),
        );
    }
}