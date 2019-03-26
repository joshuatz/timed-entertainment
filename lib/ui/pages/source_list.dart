import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:timed_entertainment/enums/sources.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';

class SrcListRow extends StatelessWidget {
    sourceEnum source;

    SrcListRow(this.source);

    @override
    Widget build(BuildContext context) {
        SourceMeta sourceMeta = SourceMeta(this.source); 
        return Card(
            child: Text(sourceMeta.displayName),
        );
    }
}

class SrcListPage extends StatefulWidget {
    @override
    _SrcListPageState createState() => _SrcListPageState();
}

class _SrcListPageState extends State<SrcListPage> {
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
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
                            HexColor("#389A9C"),
                            HexColor("#EBECCF"),
                        ]
                    )
                ),
                child: ListView(
                    children: <Widget>[
                        SrcListRow(sourceEnum.YOUTUBE)
                    ],
                ),
            ),
        );
    }
}