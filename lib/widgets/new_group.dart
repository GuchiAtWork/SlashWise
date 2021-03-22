import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  NewGroup(this._addNewGroup, this._userID);
  final Function _addNewGroup;
  final String _userID;

  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final _nameController = TextEditingController();
  File file;

  void _submitData() {
    if (_nameController.text.isEmpty) return;
    final enteredName = _nameController.text;

    widget._addNewGroup(enteredName, widget._userID, file);

    Navigator.of(context).pop();
  }

  void pickImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    file = File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.indigo[50],
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                //color: Theme.of(context).primaryColor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: kElevationToShadow[4],
                  color: Theme.of(context).primaryColor,
                  //border: Border.all(width: 2),
                ), //             <--- BoxDecoration here
                child: Center(
                  child: Text(
                    "New Group",
                    style: TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter group name',
                  ),
                  controller: _nameController,
                  onSubmitted: (_) => () {
                    _submitData();
                  },
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('Add Group Image'),
                    onPressed: () => pickImage(),
                  ),
                  ElevatedButton(
                    child: Text('Done'),
                    onPressed: () => _submitData(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
