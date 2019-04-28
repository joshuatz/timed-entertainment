import 'package:flutter/material.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/ui/components/form_heading.dart';
import 'package:timed_entertainment/helpers/helpers.dart';

class SourceEditorPage extends StatefulWidget {
    final bool isExistingConfig;
    final BaseSourceConfig config;

    SourceEditorPage({Key key, @required this.config, @required this.isExistingConfig});

    @override
    _SourceEditorPageState createState() => _SourceEditorPageState(isExistingConfig,config);
}
class _SourceEditorPageState extends State<SourceEditorPage> {
    int _selectedSourceTypeIndex = 0;
    YouTubeSourcesEnum _selectedYoutubeSrc = YouTubeSourcesEnum.TRENDING;
    final ActiveSourceConfigListBloc srcConfigListBloc = ActiveSourceConfigListBloc();
    bool _requireSearchTerm = false;
    final GlobalKey<ScaffoldState> _sourceEditorScaffoldState = new GlobalKey<ScaffoldState>();

    final bool _isExistingConfig;
    final BaseSourceConfig _config;
    _SourceEditorPageState(this._isExistingConfig,this._config){
        this._userDefinedNameController.text = _isExistingConfig && _config.hasUserDefinedName ? _config.userDefinedName : "";
        if (_isExistingConfig){
            _selectedYoutubeSrc = _config.youtubeSrc;
            _selectedSourceTypeIndex = _config.sourceType.index;
            _searchTextController.text = _config.searchTerm;
        }
        print(this._config.toJson());
    }

    TextEditingController _userDefinedNameController = new TextEditingController();
    TextEditingController _searchTextController = new TextEditingController();

    Widget conditionalSearchBox(){
        _requireSearchTerm = false;
        if(SourceListItem.getEnumFromIndex(_selectedSourceTypeIndex)==sourceEnum.YOUTUBE && _selectedYoutubeSrc == YouTubeSourcesEnum.SEARCH_TERM){
            _requireSearchTerm = true;
        }
        if (_requireSearchTerm){
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Spacer(flex: 1,),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Icon(Icons.search),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                            autocorrect: false,
                            controller: _searchTextController,
                        ),
                    ),
                    Spacer(flex: 3,)
                ],
            );
        }
        else {
            return Container();
        }
    }

    // Method to show a different inner form depending on which source type is selected
    Widget buildInnerForm(int selectedSourceTypeIndex){
        // Youtube
        if (SourceListItem.getEnumFromIndex(selectedSourceTypeIndex)==sourceEnum.YOUTUBE){
            // return Builder(
                // builder: (BuildContext context){
                    return Column(
                        children: <Widget>[
                            FormHeading(title:"What part of YouTube should this source be from?"),
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Column(
                                    children: <Widget>[
                                        RadioListTile(
                                            title: const Text("Trending"),
                                            value:YouTubeSourcesEnum.TRENDING,
                                            groupValue: _selectedYoutubeSrc,
                                            onChanged: (YouTubeSourcesEnum value) { setState(() { _selectedYoutubeSrc = value; }); },
                                        ),
                                        RadioListTile(
                                            title: const Text("Search"),
                                            value:YouTubeSourcesEnum.SEARCH_TERM,
                                            groupValue: _selectedYoutubeSrc,
                                            onChanged: (YouTubeSourcesEnum value) { setState(() { _selectedYoutubeSrc = value; }); },
                                        ),
                                        conditionalSearchBox(),
                                        RadioListTile(
                                            title: const Text("My Subscriptions"),
                                            value:YouTubeSourcesEnum.SUBSCRIPTIONS,
                                            groupValue: _selectedYoutubeSrc,
                                            // @TODO uncomment when implemented auth
                                            // onChanged: (YouTubeSourcesEnum value) { setState(() { _selectedYoutubeSrc = value; }); },
                                        )
                                    ],
                                ),
                            )
                        ],
                    );
                // },
            // );
        }
        else {
            return Text("Uh Oh!");
        }
    }

    @override
    Widget build(BuildContext context){
        final String _title = "Source Editor - " + (widget.isExistingConfig ? "Edit" : "New");
        return Scaffold(
            key: _sourceEditorScaffoldState,
            appBar: AppBar(
                title: Text(_title),
            ),
            body: Stack(
                children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                                // OPTIONAL: Custom name for source
                                FormHeading(title: "Optional: Name for this source (will appear in menus)",),
                                Row(
                                    children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            child: Icon(Icons.title),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            child: TextField(
                                                autocorrect: false,
                                                controller: _userDefinedNameController,
                                                // onChanged: (text)=>_userDefinedNameController.text = text,
                                                onChanged: (t){
                                                    print(_userDefinedNameController.text);
                                                },
                                            ),
                                        )
                                    ],
                                ),
                                // Type of Source (YouTube, Local Media, Etc.)
                                FormHeading(title: "Where should media be pulled from?"),
                                Row(
                                    children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            child: Icon(Icons.tv),
                                        ),
                                        DropdownButton(
                                            value: sourceTypeList[_selectedSourceTypeIndex],
                                            items: sourceTypeList.map<DropdownMenuItem<SourceListItem>>((item){
                                                return DropdownMenuItem<SourceListItem>(
                                                    value: item,
                                                    child: Text(item.title),
                                                );
                                            }).toList(),
                                            onChanged: (item){
                                                this.setState((){
                                                    print(item.title);
                                                    _selectedSourceTypeIndex = item.enumIndex;
                                                });
                                            },
                                        )
                                    ],
                                ),
                                buildInnerForm(this._selectedSourceTypeIndex),
                            ],
                        ),
                    ),
                    // Save button (FAB), right aligned at bottom
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            child: IconButton(
                                icon: Icon(Icons.save),
                                onPressed: (){
                                    print("Submitting Form");
                                    bool success = this.submitForm();
                                    if (success) {
                                        Navigator.pop(context);
                                    }
                                    else {
                                        _sourceEditorScaffoldState.currentState.showSnackBar(StdSnackBar(
                                            text: "Could not submit form. Have you filled out all required fields?",
                                            dismissable: true,
                                            context: _sourceEditorScaffoldState.currentState.context,
                                        ));
                                    }
                                },
                            ),
                            onPressed: ()=>{},
                        )
                    )
                ]
            )
        );
    }

    bool submitForm(){
        bool success = true;
        BaseSourceConfig _emptyConfig = new BaseSourceConfig();
        if (_userDefinedNameController.text!=""){
            _config.hasUserDefinedName = true;
            _config.userDefinedName = _userDefinedNameController.text;
        }
        if (_requireSearchTerm){
            _config.searchTerm = _searchTextController.text;
            success = _searchTextController.text=="" ? false : success;
        }
        _config.sourceType = SourceListItem.getEnumFromIndex(_selectedSourceTypeIndex);
        _config.youtubeSrc = _selectedYoutubeSrc;
        // @TODO
        if (success){
            if  (!widget.isExistingConfig){
                print(_config.toJson().toString());
                srcConfigListBloc.dispatch(new SrcConfigChange(
                    action: srcConfigActions.CREATE,
                    config: _config
                ));
            }
            else {
                print("Updating config #" + _config.configId.toString());
                srcConfigListBloc.dispatch(new SrcConfigChange(
                    action: srcConfigActions.UPDATE,
                    config: _config
                ));
            }
        }
        return success;
    }

    @override
    void dispose(){
        _userDefinedNameController.dispose();
        _searchTextController.dispose();
        super.dispose();
    }
}