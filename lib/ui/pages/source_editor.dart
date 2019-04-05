import 'package:flutter/material.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/ui/components/form_heading.dart';

class SourceEditorPage extends StatefulWidget {
    SourceEditorPage({Key key, @required this.config, @required this.isExistingConfig});

    final bool isExistingConfig;
    final BaseSourceConfig config;

    

    @override
    _SourceEditorPageState createState() => _SourceEditorPageState();
}
class _SourceEditorPageState extends State<SourceEditorPage> {
    int _selectedSourceTypeIndex = 0;
    YouTubeSourcesEnum _selectedYoutubeSrc = YouTubeSourcesEnum.TRENDING;
    String _userSpecifiedName = "";
    String _userSearchTerm = "";
    final ActiveSourceConfigListBloc srcConfigListBloc = ActiveSourceConfigListBloc();

    Widget conditionalSearchBox(){
        bool _showSearchBox = false;
        if(SourceListItem.getEnumFromIndex(_selectedSourceTypeIndex)==sourceEnum.YOUTUBE && _selectedYoutubeSrc ==YouTubeSourcesEnum.SEARCH_TERM){
            _showSearchBox = true;
        }
        if (_showSearchBox){
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
                                                onChanged: (String input){
                                                    _userSpecifiedName = input;
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
                                    this.submitForm();
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
        bool success = false;
        BaseSourceConfig _config = new BaseSourceConfig();
        if (_userSpecifiedName!=""){
            _config.hasUserDefinedName = true;
            _config.userDefinedName = _userSpecifiedName;
        }
        // @TODO
        if  (!widget.isExistingConfig){
            srcConfigListBloc.dispatch(new SrcConfigChange(
                action: srcConfigActions.CREATE,
                config: _config
            ));
        }
        return success;
    }
}