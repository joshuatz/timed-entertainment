import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';

class SrcBox extends StatelessWidget {
    final BaseSourceConfig srcConfig;
    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();
    SrcBox({Key key,@required this.srcConfig}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        // ActiveSourceConfigListBloc _srcConfigBloc = BlocProvider.of<ActiveSourceConfigListBloc>(context);
        SourceMeta sourceMeta = SourceMeta(srcConfig.sourceType); 
        String _displayName = srcConfig.hasUserDefinedName ? srcConfig.userDefinedName :sourceMeta.displayName;
        return Card(
            margin: EdgeInsets.all(10),
            elevation: 10,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        sourceMeta.icon,
                        Text(_displayName),
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
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                                return AlertDialog(
                                                    title: Text('Are you sure?'),
                                                    content: Text('This will delete the source for ever'),
                                                    actions: <Widget>[
                                                        FlatButton(
                                                            child: Text('Cancel'),
                                                            onPressed: (){
                                                                _srcConfigBloc.dispatch(SrcConfigChange(action: srcConfigActions.RESETALL,config: srcConfig));
                                                                Navigator.of(context).pop();
                                                            },
                                                        ),
                                                        FlatButton(
                                                            child: Text('DELETE',style: TextStyle(color: Colors.red),),
                                                            onPressed: (){
                                                                _srcConfigBloc.dispatch(SrcConfigChange(
                                                                    action: srcConfigActions.DELETE,
                                                                    config:srcConfig
                                                                ));
                                                                Navigator.of(context).pop();
                                                            },
                                                        )
                                                    ],
                                                );
                                            }
                                        )
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