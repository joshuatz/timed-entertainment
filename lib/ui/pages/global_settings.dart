import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_entertainment/ui/components/global_settings_help.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';

class GlobalSettingsPage extends StatefulWidget {
    @override
    _GlobalSettingsPageState createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
    // @TODO - is this in the best spot for performance? Check redraws
    final UserSettingsAllowRepeatsBloc _alllowRepeatsBloc = UserSettingsAllowRepeatsBloc();
    final UserSettingsMinElapsedForRepeatBloc _minElapsedBloc =UserSettingsMinElapsedForRepeatBloc();
    final ActiveSourceConfigListBloc _activeSourceConfigListBloc =ActiveSourceConfigListBloc();
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
                                Builder(
                                    builder: (BuildContext context){
                                        _alllowRepeatsBloc.loadFromStorage();
                                        return BlocBuilder<void,bool>(
                                            bloc: _alllowRepeatsBloc,
                                            builder: (BuildContext context,bool state){
                                                return SwitchListTile(
                                                    title: const Text("Allow Repeats"),
                                                    value: state,
                                                    onChanged: (bool val){
                                                        _alllowRepeatsBloc.dispatch(VoidFunc);
                                                    },
                                                    secondary: const Icon(Icons.loop),
                                                );
                                            }
                                        );
                                    }
                                ),
                                Divider(
                                    color: Colors.black,
                                    height: 10,
                                ),
                                Builder(
                                    builder: (BuildContext context){
                                        _minElapsedBloc.loadFromStorage();
                                        return Column(
                                            children: <Widget>[
                                                Text("Minimum Time Before Repeating Video"),
                                                Row(
                                                    children: <Widget>[
                                                        Container(
                                                            width: MediaQuery.of(context).size.width *0.05,
                                                        ),
                                                        BlocBuilder(
                                                            bloc: _minElapsedBloc,
                                                            builder: (BuildContext context, Duration state){
                                                                return Text(state.inDays.toString() + " Days");
                                                            },
                                                        ),
                                                        IconButton(
                                                            icon: Icon(Icons.remove),
                                                            onPressed: (){
                                                                _minElapsedBloc.deductDay();
                                                            },
                                                        ),
                                                        IconButton(
                                                            icon: Icon(Icons.add),
                                                            onPressed: (){
                                                                _minElapsedBloc.addDay();
                                                            },
                                                        )
                                                    ],
                                                )
                                            ]
                                        );
                                    }
                                ),
                                FlatButton(
                                    child: Text("Reset Sources"),
                                    onPressed: ()=>_activeSourceConfigListBloc.reset(),
                                )
                            ],
                        ),
                        Row(
                            children: <Widget>[
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.help),
                                    tooltip: "About this App",
                                    onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => GlobalSettingsHelpModal()
                                        );
                                    },
                                )
                            ],
                        )
                    ]
                )
            ),
        );
    }
    @override
    void dispose() {
        _alllowRepeatsBloc.dispose();
        _minElapsedBloc.dispose();
        super.dispose();
    }
}