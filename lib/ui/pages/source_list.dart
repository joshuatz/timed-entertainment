import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/ui/pages/source_editor.dart';

class SrcListRow extends StatelessWidget {
    final BaseSourceConfig srcConfig;
    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();

    SrcListRow({Key key,@required this.srcConfig}) : super(key: key);

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
                                onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SourceEditorPage(
                                            isExistingConfig: false,
                                            config: BaseSourceConfig(),
                                        ))
                                    );
                                },
                                child: const Text('Add New Source'),
                                minWidth: (MediaQuery.of(context).size.width) * 0.8,
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                            ),
                            BlocProviderTree(
                                blocProviders: [
                                    BlocProvider<ActiveSourceConfigListBloc>(bloc: new ActiveSourceConfigListBloc(),)
                                ],
                                child: Builder(
                                    builder: (BuildContext context){
                                        var _bloc = BlocProvider.of<ActiveSourceConfigListBloc>(context);
                                    return Expanded(

                                        // child: BlocBuilder(
                                        //     bloc: BlocProvider.of<ActiveSourceConfigListBloc>(context),
                                        //     builder: (BuildContext context,Map state){
                                        //         print('Building ListView for srcConfigs');
                                        //         return new ListView.builder(
                                        //             physics: AlwaysScrollableScrollPhysics(),
                                        //             shrinkWrap: false,
                                        //             itemCount: state.length,
                                        //             itemBuilder: (BuildContext context, int index){
                                        //                 return SrcListRow(
                                        //                     srcConfig: state[state.keys.elementAt(index)],
                                        //                 );
                                        //             },
                                        //         );
                                        //     },
                                        // ),


                                        child:StreamBuilder(
                                            stream: BlocProvider.of<ActiveSourceConfigListBloc>(context).state,
                                            initialData: _bloc.initialState,
                                            builder: (BuildContext context,AsyncSnapshot state){
                                                print('Building ListView for srcConfigs');
                                                return new ListView.builder(
                                                    physics: AlwaysScrollableScrollPhysics(),
                                                    shrinkWrap: false,
                                                    itemCount: state.data.length,
                                                    itemBuilder: (BuildContext context, int index){
                                                        return SrcListRow(
                                                            srcConfig: state.data[state.data.keys.elementAt(index)],
                                                        );
                                                    },
                                                );
                                            },
                                        )
                                    );
                                })
                            ),
                        ]
                    )
                )
            ),
        );
    }

    @override
    void dispose(){
        //
        super.dispose();
    }
}