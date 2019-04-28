import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:timed_entertainment/ui/pages/source_list.dart';
import 'package:timed_entertainment/ui/pages/global_settings.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/ui/components/current_source_box.dart';
import 'package:timed_entertainment/ui/pages/player.dart';
import 'package:timed_entertainment/models/sources.dart';
import 'package:timed_entertainment/apis/youtube.dart';
import 'package:timed_entertainment/state/user_settings_bloc.dart';
import 'package:timed_entertainment/helpers/helpers.dart';
import 'package:timed_entertainment/credentials.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Timed Entertainment',
            theme: ThemeData(
                // This is the theme of your application.
                primarySwatch: Colors.blue,
                primaryColor: HexColor("#136378"),
                primaryColorDark: HexColor("#136378"),
                primaryColorLight: HexColor("#389A9C"),
                // accentColor: HexColor("#389A9C"),
                accentColor: HexColor("#0E4A5A"),
            ),
            home: MyHomePage(title: 'Timed Entertainment'),
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
    // how it looks.

    // This class is the configuration for the state. It holds the values (in this
    // case the title) provided by the parent (in this case the App widget) and
    // used by the build method of the State. Fields in a Widget subclass are
    // always marked "final".

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    _MyHomePageState(){
        _srcConfigBloc.loadFromStorage();
        _hasSelectedConfigBloc.loadFromStorage();
    }

    final ActiveSourceConfigListBloc _srcConfigBloc = ActiveSourceConfigListBloc();
    final UserSettingsHasSelectedSrcConfigBloc _hasSelectedConfigBloc = UserSettingsHasSelectedSrcConfigBloc();
    final UserSettingsSelectedSrcConfig _selectedSrcConfigBloc = UserSettingsSelectedSrcConfig();


    final bool mockMode = false;

    // Global / App state
    Duration _userSelectedDuration = Duration(minutes: 3,seconds: 0);
    bool _isWaitingOnAsync = false;

    @override
    Widget build(BuildContext context) {
        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            key: Key("rootScaffold"),
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                backgroundColor: Theme.of(context).primaryColor,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.developer_mode),
                        onPressed: (){
                            _srcConfigBloc.loadFromStorage();
                        },
                    ),
                    IconButton(
                        icon: Icon(Icons.settings),
                        tooltip: 'Global Settings',
                        onPressed: ()=>{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GlobalSettingsPage()
                                )
                            )
                        },
                    )
                ],
            ),
            body: OrientationBuilder(
                builder: (BuildContext context, Orientation orientation){
                    BuildContext _orientationWrapperContext = context;
                    bool _orientationIsPortrait = (orientation == Orientation.portrait);
                    const List<StaggeredTile> _portraitStagTiles = const <StaggeredTile>[
                        StaggeredTile.count(6,3), /// Clock
                        StaggeredTile.count(6,2), /// Buttons
                        StaggeredTile.count(6,2), /// Curr Source Box
                    ];
                    const List<StaggeredTile> _landscapeStagTiles = const <StaggeredTile>[
                        StaggeredTile.count(6,4), /// Clock
                        StaggeredTile.count(3,7), /// Buttons
                        StaggeredTile.count(3,7), /// Curr Source Box
                    ];
                    print("_orientationIsPortrait = " + _orientationIsPortrait.toString());
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                    Colors.blue,
                                    HexColor("#389A9C"),
                                ]
                            )
                        ),
                        child: Center(
                            child: Stack(
                                children: <Widget>[
                                    // Column(
                                    StaggeredGridView.count(
                                        crossAxisCount: _orientationIsPortrait ? 6 : 6,
                                        shrinkWrap: false,
                                        physics: NeverScrollableScrollPhysics(),
                                        // shrinkWrap: false,
                                        padding: _orientationIsPortrait ? EdgeInsets.only(top: 10) : EdgeInsets.all(6),
                                        mainAxisSpacing: _orientationIsPortrait ? 0 : 5,
                                        crossAxisSpacing: _orientationIsPortrait ? 0 : 0,
                                        scrollDirection: _orientationIsPortrait ? Axis.vertical : Axis.horizontal,
                                        staggeredTiles: _orientationIsPortrait ? _portraitStagTiles : _landscapeStagTiles,
                                        children: <Widget>[
                                            Builder(builder: (BuildContext context){
                                                return DurationPicker(
                                                    // height: MediaQuery.of(_orientationWrapperContext).size.height * (_orientationIsPortrait ? 0.35 : 0.9),
                                                    // width: MediaQuery.of(_orientationWrapperContext).size.width * (_orientationIsPortrait ? 0.8 : 0.5),
                                                    duration: _userSelectedDuration,
                                                    onChange: (val){
                                                        if (val.inMinutes != 0){
                                                            this.setState(()=>{
                                                                _userSelectedDuration = val
                                                            });
                                                        }
                                                        else {
                                                            this.setState(()=>{
                                                                _userSelectedDuration = Duration(minutes: 1)
                                                            });
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                duration: Duration(seconds: 2),
                                                                content: Text("Must be >= 1 minute"),
                                                                action: SnackBarAction(
                                                                    label: "Dismiss",
                                                                    onPressed: (){
                                                                        Scaffold.of(context).hideCurrentSnackBar();
                                                                    },
                                                                ),
                                                            ));
                                                        }
                                                    },
                                                );
                                            }),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                    MaterialButton(
                                                        onPressed: (){
                                                            handleStart(context);
                                                        },
                                                        child: const Text('Start'),
                                                        color: Theme.of(context).accentColor,
                                                        textColor: Colors.white,
                                                        minWidth: (MediaQuery.of(context).size.width) * 0.8,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                            MaterialButton(
                                                                onPressed: (){
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => SrcListPage(_srcConfigBloc))
                                                                    );
                                                                },
                                                                child: const Text('Edit Sources'),
                                                                color: Theme.of(context).accentColor,
                                                                textColor: Colors.white,
                                                                // minWidth: (MediaQuery.of(context).size.width) * 0.8,
                                                            ),
                                                            MaterialButton(
                                                                onPressed: (){
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder: (context) => SrcListPage(_srcConfigBloc,true))
                                                                    );
                                                                },
                                                                child: const Text('Select Source'),
                                                                color: Theme.of(context).accentColor,
                                                                textColor: Colors.white,
                                                                // minWidth: (MediaQuery.of(context).size.width) * 0.8,
                                                            ),
                                                        ],
                                                    ),
                                                ],
                                            ),
                                            Center (
                                                child: CurrentSourceBox(),
                                            ),
                                        ],
                                    ),
                                    buildLoadingIndicator(context),
                                ],
                            )
                            
                        ),
                    );
                }
            )
        );
    }
    
    @override
    void dispose(){
        super.dispose();
    }

    void toggleLoader(){
        setState(() {
            _isWaitingOnAsync = !_isWaitingOnAsync; 
        });
    }

    void handleYoutubeResult(YouTubeSingleResult result){
        if (result.success){
            toggleLoader();
            print(result.id);
            print(result.duration.toString());
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context){
                    return PlayerPage(
                        timerDuration: _userSelectedDuration,
                        source: sourceEnum.YOUTUBE,
                        youtubeVideo: result,
                    );
                })
            );
        }
        else {
            toggleLoader();
            Scaffold.of(context).showSnackBar(StdSnackBar(
                text: "Could not find video! - but Future<> completed",
                dismissable: true,
                context: context,
            )); 
        }
    }

    void handleStart(BuildContext context){
        BaseSourceConfig _currConfig = _selectedSrcConfigBloc.currentState;
        // Check that there is a source selected...
        if (_hasSelectedConfigBloc.currentState){
            setState(() {
                _isWaitingOnAsync = true; 
            });
            /// call async api functions
            /// YouTubeSearch(Credentials.YouTube, "fireship.io", 2).searchByDuration(_userSelectedDuration, true).then((YouTubeSingleResult result){
            if (_currConfig.sourceType == sourceEnum.YOUTUBE){
                if (_currConfig.youtubeSrc == YouTubeSourcesEnum.SEARCH_TERM){
                    // YouTubeSearchByTerm(Credentials.YouTube, "fireship.io", 2,true).searchByDuration(_userSelectedDuration, true).then((result){
                    YouTubeSearchByTerm(Credentials.YouTube,_currConfig.searchTerm, 2,mockMode).searchByDuration(_userSelectedDuration, true).then((result){
                        handleYoutubeResult(result);
                    }).catchError((err){
                        toggleLoader();
                        Scaffold.of(context).showSnackBar(StdSnackBar(
                            text: "Could not find video!",
                            dismissable: true,
                            context: context,
                        ));
                    });
                }
                else if (_currConfig.youtubeSrc == YouTubeSourcesEnum.TRENDING){
                    YouTubeSearchTrending(Credentials.YouTube, 2,mockMode).searchByDuration(_userSelectedDuration, true).then((result){
                        handleYoutubeResult(result);
                    }).catchError((err){
                        toggleLoader();
                        Scaffold.of(context).showSnackBar(StdSnackBar(
                            text: "Could not find video!",
                            dismissable: true,
                            context: context,
                        ));
                    });
                }
            }
        }
        else {
            Scaffold.of(context).showSnackBar(StdSnackBar(
                text: "No source selected!",
                dismissable: true,
                context: context,
            ));
        }
    }

    Widget buildLoadingIndicator (BuildContext context) {
        if (_isWaitingOnAsync){
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white70
                ),
                child: Center(
                    child: CircularProgressIndicator()
                ),
            );
        }
        else {
            return Container();
        }
    }
}
