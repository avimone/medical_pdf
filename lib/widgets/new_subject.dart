import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewSubject extends StatefulWidget {
  final Function addTx;

  NewSubject(this.addTx);

  @override
  _NewSubjectState createState() => _NewSubjectState();
}

class _NewSubjectState extends State<NewSubject> {
  final _titleController = TextEditingController();
  final _idController = TextEditingController();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredId = int.parse(_idController.text);
    if (enteredId != 1989 || enteredId == null) {
      _showMyDialog();
    } else {
      widget.addTx(
        enteredTitle,
      );

      Navigator.of(context).pop();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!!! Data only entered by admin'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('you can mail details to 40avirajpatel@gmail.com'),
                Text('or whatsapp details to 7014799875'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'id'),
                controller: _idController,

                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
