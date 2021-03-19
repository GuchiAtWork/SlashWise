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
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppBar(
                title: Text(
                "Create a new group"
                ),
              ),
              Container(              
                height: 100,
                child: TextField(
                  style: TextStyle(
                    fontSize: 25.0,
                    height: 2.0,
                    color: Colors.black                  
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter group name',
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
                    child: Text('Add Group Image 📷'),
                    onPressed: () => pickImage(),
                  ),
                  ElevatedButton(
                    child: Text('Done ✅'),
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
