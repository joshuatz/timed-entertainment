import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class GlobalSettingsPage extends StatefulWidget {
    @override
    _GlobalSettingsPageState createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text("Global Settings"),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                                Container(
                                    child: SwitchListTile(
                                        title: const Text("foooooooooooooo"),
                                        value: false,
                                        onChanged: (bool val){
                                            //
                                        },
                                        secondary: const Icon(Icons.lightbulb_outline),
                                    ),
                                )
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.help),
                                    tooltip: "About this App",
                                    onPressed: ()=>{},
                                )
                            ],
                        )
                    ]
                )
            ),
        );
    }
}