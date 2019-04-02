import 'package:flutter/material.dart';
import 'repository/repository.dart';
import 'package:flutter_sugar/model/entry.dart';
import 'entries_list.dart';
import 'chart.dart';
import 'summary.dart';

class SugarPage extends StatefulWidget {
  SugarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SugarPageState createState() => _SugarPageState();
}

class _SugarPageState extends State<SugarPage> {
  var repository = Repository();

  void _incrementCounter() {
    setState(() {});

    //var r = Repository();
    //r.add(Entry(null, "First", 2.8, DateTime.now().millisecondsSinceEpoch));
    //r.add(Entry(null, "Second", 4.3, DateTime.now().millisecondsSinceEpoch));
    // TODO: calculate statistics for info
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_summary(), _chart(), _listContainer()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add entry',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _chart() => Container(
      color: Colors.blueGrey,
      child: CustomPaint(painter: Chart(), child: Container(height: 80)));

  Widget _summary() => FutureBuilder(
      future: repository.list(),
      builder: (BuildContext context,
              AsyncSnapshot<Map<String, List<Entry>>> snapshot) =>
          _handleEntriesFuture(snapshot, (data) {
            var allEntries = List<Entry>();
            data.values.forEach((entries) => allEntries.addAll(entries));
            return Summary(allEntries);
          }));

  _listContainer() => Expanded(
        child: FutureBuilder(
            future: repository.list(),
            builder: (BuildContext context,
                    AsyncSnapshot<Map<String, List<Entry>>> snapshot) =>
                _handleEntriesFuture(snapshot, (data) => _buildListView(data))),
      );

  _handleEntriesFuture(AsyncSnapshot<Map<String, List<Entry>>> snapshot,
      Function(Map<String, List<Entry>>) callback) {
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
            return callback(snapshot.data);
          }
        }
    }
  }

  _buildLoadingView() => Center(
        child: CircularProgressIndicator(),
      );

  _buildError(String errorMessage) => Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(errorMessage),
      ));

  _buildListView(Map<String, List<Entry>> entries) {
    if (entries.isEmpty) {
      return _buildError("Nothing found");
    }
    return EntryList(entries);
  }
}
