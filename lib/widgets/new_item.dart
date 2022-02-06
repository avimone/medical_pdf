import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewItem extends StatefulWidget {
  final Function addTx;

  NewItem(this.addTx);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _imageController = TextEditingController();
  final _idController = TextEditingController();

  void _submitData() {
    var enteredTitle = _titleController.text;
    var enteredLink = _linkController.text;
    var enteredImage = _imageController.text;
    var enteredId = int.parse(_idController.text);

    // enteredLink = "https://gadgetspidy.com/medical/";

    //  enteredImage =
    //    "https://gadgetspidy.com/petroleum_images/No_Image_Available.png";

    /*  if (enteredId != 1989 || enteredId == null) {
      _showMyDialog();
    } else { */
    if (enteredLink == null) {
      enteredLink = "https://gadgetspidy.com/medical/";
    }
    if (enteredImage == null) {
      enteredImage =
          "https://gadgetspidy.com/petroleum_images/No_Image_Available.png";
    }
    if (enteredId == null) {
      enteredId = 111;
    }
    if (enteredTitle == null) {
      enteredTitle = "null";
    }
    widget.addTx(
      enteredTitle,
      enteredId,
      enteredImage,
      enteredLink,
    );

    Navigator.of(context).pop();
    /*  } */
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
                decoration: InputDecoration(labelText: 'link'),
                controller: _linkController,

                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'imageUrl'),
                controller: _imageController,

                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'id'),
                controller: _idController,

                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
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
