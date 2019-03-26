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
                child: ListView(
                    children: <Widget>[],
                ),
            ),
        );
    }
}