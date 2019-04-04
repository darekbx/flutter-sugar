import 'package:flutter/material.dart';
import 'package:flutter_sugar/model/entry.dart';
import 'repository/repository.dart';

class EntryDialog extends StatefulWidget {
  EntryDialog({this.callback});

  final Function() callback;

  @override
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final _descriptionController = TextEditingController();
  final _sugarController = TextEditingController();
  bool _descriptionError = false;
  bool _sugarError = false;

  @override
  Widget build(BuildContext context) => entryDialog(context);

  @override
  void dispose() {
    _descriptionController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  AlertDialog entryDialog(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("New entry")),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _descriptionInput(),
        Row(children: <Widget>[
          Flexible(flex: 3, child: _sugarInput()),
          Flexible(flex: 1, child: _calculateButton())
        ])
      ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: () => _saveEntry(context),
        )
      ],
    );
  }

  _saveEntry(BuildContext context) async {
    var description = _descriptionController.text;
    var sugar = _sugarController.text;

    setState(() {
      _descriptionError = _descriptionController.text.isEmpty;
      _sugarError = _sugarController.text.isEmpty || double.tryParse(sugar) == null;
    });

    if (_descriptionError || _sugarError) {
      return;
    }

    var entry = Entry(null, description, double.parse(sugar),
        DateTime.now().millisecondsSinceEpoch);
    await Repository().add(entry);
    Navigator.pop(context);
    widget.callback();
  }

  Widget _descriptionInput() => TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Description',
          errorText:
              _descriptionError ? "Description can't be empty" : null));

  Widget _sugarInput() => TextField(
      controller: _sugarController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Sugar [g]',
          errorText: _sugarError ? "Amount is invalid" : null));

  Widget _calculateButton() => FlatButton(
        child: Icon(Icons.keyboard),
        onPressed: () {},
      );
}
