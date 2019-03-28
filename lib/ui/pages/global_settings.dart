import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timed_entertainment/ui/components/global_settings_help.dart';

class GlobalSettingsPage extends StatefulWidget {
    @override
    _GlobalSettingsPageState createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
    // @TODO - is this in the best spot for performance? Check redraws
    final UserSettingsAllowRepeatsBloc _myBloc = UserSettingsAllowRepeatsBloc();
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
                                        _myBloc.loadFromStorage();
                                        return BlocBuilder<void,bool>(
                                            bloc: _myBloc,
                                            builder: (BuildContext context,bool state){
                                                return SwitchListTile(
                                                    title: const Text("Allow Repeats"),
                                                    value: state,
                                                    onChanged: (bool val){
                                                        _myBloc.dispatch(VoidFunc);
                                                    },
                                                    secondary: const Icon(Icons.loop),
                                                );
                                            }
                                        );
                                    }
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
        _myBloc.dispose();
        super.dispose();
    }
}