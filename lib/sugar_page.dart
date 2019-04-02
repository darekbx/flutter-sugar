import 'package:flutter/material.dart';
import 'repository/repository.dart';
import 'package:flutter_sugar/model/entry.dart';
import 'entries_list.dart';
import 'chart.dart';

class SugarPage extends StatefulWidget {
  SugarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SugarPageState createState() => _SugarPageState();
}

class _SugarPageState extends State<SugarPage> {
  var repository = Repository();

  double _todaysSugar = 22.8;
  int _itemsCount = 52;
  double _suagerEaten = 0.249;

  void _incrementCounter() {
    setState(() {
      _todaysSugar += 0.1;
    });

    debug();
  }

  void debug() async {
    var r = Repository();
    //r.add(Entry(null, "First", 2.8, DateTime.now().millisecondsSinceEpoch));
    //r.add(Entry(null, "Second", 2.8, DateTime.now().millisecondsSinceEpoch));
    //var results = await r.list();
    //results.forEach((a, b) {
    //  print("$a = ${b.length}");
    //});
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
            padding: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    defaultText('Today\'s sugar: ', 28),
                    defaultText("${_todaysSugar.toStringAsFixed(1)}g", 28, Colors.lightGreenAccent),
                  ]),
                  defaultText('Item\'s count: $_itemsCount', 18),
                  defaultText('Sugar eaten: ${_suagerEaten.toStringAsFixed(1)}kg', 18),
                ]))
      ]));

  Widget chart() => Container(
      color: Colors.blueGrey,
      child: CustomPaint(painter: Chart(), child: Container(height: 80)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[topInformations(), chart(), _listContainer()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add entry',
        child: Icon(Icons.add),
      ),
    );
  }

  _listContainer() => Expanded(
        child: FutureBuilder(
            future: repository.list(),
            builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<Entry>>> snapshot) =>
                _handleListFuture(context, snapshot)),
      );

  _handleListFuture(
      BuildContext context, AsyncSnapshot<Map<String, List<Entry>>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return _buildLoadingView();
      default:
        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        } else {
          if (snapshot.data == null) {
            return _buildError("Error :( ");
          } else {
            return _buildListView(context, snapshot.data);
          }
        }
    }
  }

  _buildLoadingView() => Center(
        child: CircularProgressIndicator(),
      );

  _buildError(String errorMessage) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      );

  _buildListView(BuildContext context, Map<String, List<Entry>> entries) =>
      EntryList(entries);
}
