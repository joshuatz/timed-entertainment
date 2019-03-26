import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timed_entertainment/HexColor.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                primaryColor: HexColor("#136378"),
                primaryColorDark: HexColor("#136378"),
                primaryColorLight: HexColor("#389A9C"),
                accentColor: HexColor("#4BB175"),
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
    }
    // Color Scheme
    Map<String,Color> colorScheme = {
        'primary' : HexColor("#136378")
    };
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
    int _counter = 0;

    void _incrementCounter() {
        setState(() {
            _counter++;
        });
    }

    Duration _userSelectedDuration = Duration(minutes: 3,seconds: 0);

    @override
    Widget build(BuildContext context) {
        // This method is rerun every time setState is called, for instance as done
        // by the _incrementCounter method above.
        //
        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                backgroundColor: Theme.of(context).primaryColor,
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
                            // CupertinoTimerPicker(
                            //     mode: CupertinoTimerPickerMode.ms,
                            //     initialTimerDuration: Duration(minutes: 3,seconds: 0),
                            //     minuteInterval: 1,
                            //     onTimerDurationChanged: (update)=>{},
                            // ),
                            DurationPicker(
                                duration: _userSelectedDuration,
                                onChange: (val)=>{
                                    this.setState(()=>{
                                        _userSelectedDuration = val
                                    })
                                },
                            ),
                            MaterialButton(
                                onPressed: ()=>{},
                                child: const Text('Start'),
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                minWidth: (MediaQuery.of(context).size.width) * 0.8,
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
