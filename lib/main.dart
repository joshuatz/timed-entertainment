import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:timed_entertainment/ui/pages/source_list.dart';
import 'package:timed_entertainment/ui/pages/global_settings.dart';
import 'package:timed_entertainment/state/src_configs_bloc.dart';
import 'package:timed_entertainment/ui/components/current_source_box.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                // This is the theme of your application.
                primarySwatch: Colors.blue,
                primaryColor: HexColor("#136378"),
                primaryColorDark: HexColor("#136378"),
                primaryColorLight: HexColor("#389A9C"),
                // accentColor: HexColor("#389A9C"),
                accentColor: HexColor("#0E4A5A"),
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
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

    // Global / App state
    Duration _userSelectedDuration = Duration(minutes: 3,seconds: 0);
    int currentlySelectedSourceId = 0;

    @override
    Widget build(BuildContext context) {
        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                backgroundColor: Theme.of(context).primaryColor,
                actions: <Widget>[
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
            body: Container(
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Builder(builder: (BuildContext context){
                                return DurationPicker(
                                    height: MediaQuery.of(context).size.height * 0.4,
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
                            
                            MaterialButton(
                                onPressed: ()=>{},
                                child: const Text('Start'),
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                minWidth: (MediaQuery.of(context).size.width) * 0.8,
                            ),
                            MaterialButton(
                                onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SrcListPage())
                                    );
                                },
                                child: const Text('Configure Sources'),
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                minWidth: (MediaQuery.of(context).size.width) * 0.8,
                            ),
                            // Current Source
                            // @TODO
                            CurrentSourceBox()
                        ],
                    ),
                ),
            ),
        );
    }
}
