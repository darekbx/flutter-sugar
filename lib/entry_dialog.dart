import 'package:flutter/material.dart';
import 'package:flutter_sugar/model/entry.dart';
import 'repository/repository.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class EntryDialog extends StatefulWidget {
  EntryDialog({this.callback});

  final Function() callback;

  @override
  _EntryDialogState createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  GlobalKey<AutoCompleteTextFieldState<Entry>> _key = new GlobalKey();
  AutoCompleteTextField _descriptionTextField;
  final _sugarController = TextEditingController();
  bool _descriptionError = false;
  bool _sugarError = false;
  TextEditingController controller = new TextEditingController();
  List<Entry> _data = List();

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => entryDialog(context);

  @override
  void dispose() {
    _sugarController.dispose();
    super.dispose();
  }

  void _loadEntries() async {
    var entries = await Repository().distinctList();
    setState(() {
      _data = entries;
    });
  }

  AlertDialog entryDialog(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("New entry")),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _autocompleteDescription(context),
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

  _autocompleteDescription(BuildContext context) {
    _descriptionTextField = AutoCompleteTextField<Entry>(
        decoration: InputDecoration(
            suffixIcon: Container(
              width: 85.0,
              height: 60.0,
            ),
            filled: true,
            hintText: 'Description',
            errorText: _descriptionError ? "Description can't be empty" : null),
        itemBuilder: (context, item) => Text(item.name),
        itemFilter: (item, query) =>
            item.name.toLowerCase().startsWith(query.toLowerCase()),
        itemSorter: (a, b) => a.name.compareTo(b.name),
        itemSubmitted: (item) {
          setState(() {
            _descriptionTextField.textField.controller.text = item.name;
          });
        },
        clearOnSubmit: false,
        suggestions: _data,
        key: _key);
    return _descriptionTextField;
  }

  _saveEntry(BuildContext context) async {
    var description = _descriptionTextField.textField.controller.text;
    var sugar = _sugarController.text;

    setState(() {
      _descriptionError =
          _descriptionTextField.textField.controller.text.isEmpty;
      _sugarError =
          _sugarController.text.isEmpty || double.tryParse(sugar) == null;
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

  Widget _sugarInput() => TextField(
      controller: _sugarController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Sugar [g]',
          errorText: _sugarError ? "Amount is invalid" : null));

  Widget _calculateButton() => Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: RaisedButton(
        child: Icon(Icons.keyboard),
        onPressed: () {},
      ));
}
