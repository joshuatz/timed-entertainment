import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

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
                                    //
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