import 'package:flutter/material.dart';

void main() => runApp(SugarApp());

class SugarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sugar',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: SugarPage(title: 'Sugar'),
    );
  }
}

class SugarPage extends StatefulWidget {
  SugarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SugarPageState createState() => _SugarPageState();
}

class _SugarPageState extends State<SugarPage> {

  double _todaysSugar = 22.8;
  int _itemsCount = 52;
  double _suagerEaten = 0.249;

  void _incrementCounter() {
    setState(() {
      _todaysSugar += 0.1;
    });
  }

  Widget defaultText(String text, double size, [Color color = Colors.white]) =>
      Text(
        text,
        style: TextStyle(color: color, fontSize: size, height: 1.1),
        textAlign: TextAlign.left,
      );

  Widget topInformations() => Container(
      color: Colors.blueGrey,
      child: Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    defaultText('Today\'s sugar: ', 28),
                    defaultText(
                        "${_todaysSugar.toStringAsFixed(1)}g", 28, Colors.lightGreenAccent),
                  ]),
                  defaultText('Item\'s count: $_itemsCount', 18),
                  defaultText('Sugar eaten: ${_suagerEaten.toStringAsFixed(1)}kg', 18),
                ]))
      ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          topInformations(),
          Expanded(
            child: Container(color: Colors.grey),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add entry',
        child: Icon(Icons.add),
      ),
    );
  }
}
