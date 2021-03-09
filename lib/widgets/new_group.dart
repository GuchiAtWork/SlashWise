import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  NewGroup(this._addNewGroup);
  final Function _addNewGroup;

  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final _nameController = TextEditingController();

  void _submitData() {
    if (_nameController.text.isEmpty) return;
    final enteredName = _nameController.text;

    widget._addNewGroup(enteredName);

    Navigator.of(context).pop();
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
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'name',
                  icon: Icon(Icons.group_add),
                ),
                controller: _nameController,
                onSubmitted: (_) => () {
                  _submitData();
                },
              ),
              ElevatedButton(
                child: Text('Add Group'),
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
