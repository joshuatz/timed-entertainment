import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class SrcListPage extends StatefulWidget {
    @override
    _SrcListPageState createState() => _SrcListPageState();
}

class _SrcListPageState extends State<SrcListPage> {
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text("Video Sources"),
                backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                            Colors.blue,
                            HexColor("#389A9C"),
                        ]
                    )
                ),
            ),
        );
    }
}