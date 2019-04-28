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
import 'package:timed_entertainment/state/user_settings_bloc.dart';

class SrcListRow extends StatelessWidget {
    final BaseSourceConfig srcConfig;
    final bool showEditButtons;
    SrcListRow({Key key,@required this.srcConfig,@required this.showEditButtons}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return SrcBox(
            srcConfig: this.srcConfig,
            showEditButtons: this.showEditButtons
        );
    }
}

class SrcListPage extends StatefulWidget {
    final ActiveSourceConfigListBloc _srcConfigBloc;
    final UserSettingsSelectedSrcConfig _selectedSrcConfigBloc = new UserSettingsSelectedSrcConfig();
    SrcListPage(this._srcConfigBloc,[this._selectMode = false]);
    bool _selectMode = false;
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
                            conditionallyBuildAddNewButton(),
                            BlocProviderTree(
                                blocProviders: [
                                    BlocProvider<ActiveSourceConfigListBloc>(bloc: widget._srcConfigBloc,)
                                ],
                                child: Builder(
                                    builder: (BuildContext context){
                                        var _bloc = BlocProvider.of<ActiveSourceConfigListBloc>(context);
                                        print(_bloc.currentState);
                                        return Expanded(
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
                                                            BaseSourceConfig _currConfig =  state.data[state.data.keys.elementAt(index)];
                                                            return GestureDetector(
                                                                child: SrcListRow(
                                                                    srcConfig: _currConfig,
                                                                    showEditButtons: !widget._selectMode,
                                                                ),
                                                                onTap: (){
                                                                    if (widget._selectMode){
                                                                        // Set selected config to the one clicked on
                                                                        widget._selectedSrcConfigBloc.dispatch(_currConfig.configId);
                                                                        // Navigate back!
                                                                        Navigator.pop(context);
                                                                    }
                                                                },
                                                            );
                                                        },
                                                    );
                                                },
                                            )
                                        );
                                    }
                                ),
                            ),
                        ]
                    ),
                ),
            ),
        );
    }

    @override
    void dispose(){
        super.dispose();
    }

    Widget conditionallyBuildAddNewButton(){
        if (widget._selectMode){
            return Container();
        }
        else {
            return MaterialButton(
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
            );
        }
    }
}