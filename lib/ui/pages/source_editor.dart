import 'package:flutter/material.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';

class SourceEditorPage extends StatefulWidget {
    SourceEditorPage({Key key, @required this.config, @required this.isExistingConfig});

    final bool isExistingConfig;
    final BaseSourceConfig config;

    @override
    _SourceEditorPageState createState() => _SourceEditorPageState();
}

class _SourceEditorPageState extends State<SourceEditorPage> {
    

    @override
    Widget build(BuildContext context){
        final String _title = "Source Editor - " + (widget.isExistingConfig ? "Edit" : "New");
        return Scaffold(
            appBar: AppBar(
                title: Text(_title),
            ),
            body:Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        // OPTIONAL: Custom name for source
                        Text("Optional: Name for this source (will appear in menus)"),
                        Divider(),
                        Row(
                            children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    child: Icon(Icons.title),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: TextField(
                                        autocorrect: false,
                                    ),
                                )
                            ],
                        ),
                        // Type of Source (YouTube, Local Media, Etc.)
                        Row(
                            children: <Widget>[
                                DropdownButton(
                                    items: sourceTypeList.map<DropdownMenuItem<SourceListItem>>((item){
                                        return DropdownMenuItem<SourceListItem>(
                                            value: item,
                                            child: Text(item.title),
                                        );
                                    }).toList(),
                                    onChanged: (_)=>{},
                                )
                            ],
                        )
                    ],
                )
            )
        );
    }
}