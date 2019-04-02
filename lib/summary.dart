import 'package:flutter/material.dart';
import 'package:flutter_sugar/model/entry.dart';

class Summary extends StatelessWidget {
  final List<Entry> entries;

  Summary(this.entries);

  int _itemsCount() => entries.length;

  String _sugarEaten() {
    double sum = 0.0;
    entries.forEach((entry) {
      sum += entry.sugar;
    });
    sum /= 1000;
    return sum.toStringAsFixed(3);
  }

  String _todaysSugar() {
    var date = DateTime.now();
    var nowMinusDay = date.subtract(Duration(days: 1));

    double sum = 0.0;
    entries.forEach((entry) {
      if (entry.timestamp > nowMinusDay.millisecondsSinceEpoch) {
        sum += entry.sugar;
      }
    });

    return sum.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) => Container(
      color: Colors.blueGrey,
      child: Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    defaultText('Today\'s sugar: ', 28),
                    defaultText("${_todaysSugar()}g", 28, Colors.lightGreenAccent),
                  ]),
                  defaultText('Item\'s count: ${_itemsCount()}', 18),
                  defaultText('Sugar eaten: ${_sugarEaten()}kg', 18),
                ]))
      ]));

  Widget defaultText(String text, double size, [Color color = Colors.white]) =>
      Text(
        text,
        style: TextStyle(color: color, fontSize: size, height: 1.1),
        textAlign: TextAlign.left,
      );
}
