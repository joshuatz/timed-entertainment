import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';

class SrcListRow extends StatelessWidget {
    final BaseSourceConfig srcConfig;
    final ActiveSourceConfigListBloc srcConfigListBloc =ActiveSourceConfigListBloc();
    
    SrcListRow({Key key,@required this.srcConfig}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        SourceMeta sourceMeta = SourceMeta(srcConfig.sourceType); 
        return Card(
            margin: EdgeInsets.all(10),
            elevation: 10,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        sourceMeta.icon,
                        Text(sourceMeta.displayName),
                        // Wrap action buttons (edit, delete) in extra row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                                IconButton(
                                    color: Colors.redAccent.shade200,
                                    icon: Icon(Icons.delete),
                                    onPressed: ()=>{
                                        // @TODO ask for confirm, then delete source
                                        // Use AlertDialog?
                                    },
                                ),
                                Container(
                                    // height: MediaQuery.of(context).size.height,
                                    height: 40,
                                    width: 2,
                                    color: Colors.black,
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                ),
                                IconButton(
                                    icon : Icon(Icons.edit),
                                    tooltip: "Edit",
                                    onPressed: ()=>{
                                        // @TODO route to edit page
                                    },
                                )
                            ]
                        )
                    ]
                )
            )
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
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            MaterialButton(
                                onPressed: ()=>{},
                                child: const Text('Add New Source'),
                                minWidth: (MediaQuery.of(context).size.width) * 0.8,
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                            ),
                            ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                    SrcListRow(
                                        srcConfig: new BaseSourceConfig.mock(2,sourceEnum.YOUTUBE)
                                    ),
                                    // SrcListRow(sourceEnum.LOCAL_FOLDER)
                                ],
                            ),
                        ]
                    )
                )
            ),
        );
    }
}