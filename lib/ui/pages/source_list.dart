import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/ui/pages/source_editor.dart';
import 'package:timed_entertainment/ui/components/source_box.dart';

class SrcListRow extends StatelessWidget {
    final BaseSourceConfig srcConfig;
    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();

    SrcListRow({Key key,@required this.srcConfig}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return SrcBox(srcConfig: this.srcConfig);
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