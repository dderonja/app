import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:myapp/passage.dart';
import 'package:myapp/decision.dart';
import 'package:myapp/screens/chapters.dart';
import 'package:myapp/screens/contact.dart';
import 'package:myapp/screens/diaden.dart';
import 'package:myapp/screens/settings.dart';
import 'package:myapp/showAd.dart';
import 'package:myapp/showLife.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
        dialogBackgroundColor: Colors.black,
        fontFamily: 'Times New Roman',
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Die Diebessaga'),
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

  int _counter = 0;
  int clicks = 0;
  var list;
  bool isData = false;
  int leben = 100;
  int diaden = 0;
  int moral = 10;
  ScrollController _scrollController = new ScrollController();


  setPassage(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt("_savedChapter", value);
  }

  getPassage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Saved Chapter: " + prefs.getInt("_savedChapter").toString());


    setState(() {

      _counter = prefs.getInt("_savedChapter");

    });
  }

  Future _loadPassageAsset() async {
    return await rootBundle.loadString('assets/content.json');
  }

  loadPassages() async {
    String jsonPhotos = await _loadPassageAsset();
    final jsonResponse = json.decode(jsonPhotos);

    setState(() {
      list = PassagesList.fromJson(jsonResponse);
      isData = true;
    });
    print(list.passages[0].content);
  }

  @override
  void initState() {
    print("Test");
    getPassage();
    loadPassages();
  }

  void _showDialog(BuildContext context, String content, Color color) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Center(
            heightFactor: 1,
              child: new Text(content,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: color))),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextPage(BuildContext context, int option) {
    int id = this._counter;
    Decision decision = this.list.passages[id].decision.decisions[option];
    int target_id = decision.targetId - 1;
    int new_life = this.leben + decision.leben;
    int new_moral = this.moral + decision.moral;
    int new_diaden = this.diaden + decision.diaden;

    if (new_life != this.leben) {
      if (new_life < this.leben) {
        int change = this.leben - new_life;
        _showDialog(context, "Du hast $change Leben verloren", Colors.red[900]);
      }else {
        int change = new_life - this.leben;
        _showDialog(context, "Du hast $change Leben regeneriert", Colors.green[800]);
      }
    }
    if (new_moral != this.moral) {
      if (new_moral < this.moral) {
        int change = this.moral - new_moral;
        _showDialog(context, "Du hast $change Moral verloren", Colors.red[900]);
      }else {
        int change = new_moral - this.moral;
        _showDialog(context, "Du hast $change Moral gewonnen", Colors.green[800]);
      }
    }
    if (new_diaden != this.diaden) {
      if (new_diaden < this.diaden) {
        int change = this.diaden - new_life;
        _showDialog(context, "Du hast $change Diaden verloren", Colors.red[900]);
      }else {
        int change = new_diaden - this.diaden;
        _showDialog(context, "Du hast $change Diaden gewonnen", Colors.green[800]);
      }
    }

    _scrollController.jumpTo(0);

    int ovClicks = clicks + 1;
    if (ovClicks == 5) {
      ShowNotificationIcon test = new ShowNotificationIcon();
      test.show(context);
      ovClicks = 0;
    }

    setState(() {
      leben = new_life;
      moral = new_moral;
      diaden = new_diaden;
      _counter = target_id;
      clicks = ovClicks;
    });

    setPassage(target_id);

  }

  Widget buttonView(BuildContext contextOne, DecisionList list) {
    var bView = ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  _nextPage(contextOne, index);
                },
                textColor: Colors.white,
                color: Colors.blueGrey,
                highlightColor: Colors.white,
                splashColor: Colors.red,
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(list.decisions[index].optionText,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ));
        },
        itemCount: list.decisions.length);
    return bView;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          leading: Container (),
          title: Text(widget.title),
        ),
        endDrawer: SizedBox(
            width: 170.0,
            child: new Drawer(
                child: new ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    'Einstellungen',
                    style: TextStyle(fontFamily: 'Arial'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );


                  },
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Kapitel',
                    style: TextStyle(fontFamily: 'Arial'),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chapters()),
                    );
                  },
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Hol Dir Diaden',
                    style: TextStyle(fontFamily: 'Arial'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Diaden()),
                    );
                  },
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Kontakt',
                    style: TextStyle(fontFamily: 'Arial'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contact()),
                    );
                  },
                ),
              ],
            ))),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      'Diaden: $diaden  ',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      'Moral: $moral  ',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      'Leben: $leben',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              isData
                  ? Expanded(
                      // A flexible child that will grow to fit the viewport but
                      // still be at least as big as necessary to fit its contents.
                      child: new SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(list.passages[_counter].content,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                        Padding(padding: EdgeInsets.all(10.0)),
                        buttonView(
                            context, this.list.passages[_counter].decision),
                      ]),
                    ))
                  : new Center(
                      child: new CircularProgressIndicator(),
                    ),
            ],
          ),
        ));
  }
}
