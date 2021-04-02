import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMenuItem extends StatefulWidget {
  final Function addTx;

  NewMenuItem(
    this.addTx,
  );

  @override
  _NewMenuItemState createState() {
    return _NewMenuItemState();
  }
}

class _NewMenuItemState extends State<NewMenuItem> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount,);

    Navigator.of(context).pop();
  }


 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 7,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData,
                // onChanged: (val){
                // titleInput = val;
                //      } ,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                //onChanged: (val){
                //amountInput = val;
                //}
              ),
              Container(
                height: 70,
                child: Platform.isIOS
                    ? CupertinoButton(
                        child: Text('Add Transaction!'),
                        onPressed: () {
                          _submitData();
                        },
                      )
                    : TextButton(
                        onPressed: () {
                          _submitData();
                        },
                        child: Text(
                          'Add Transaction!',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
