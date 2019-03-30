import 'package:flutter/material.dart';
import 'sugar_page.dart';

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