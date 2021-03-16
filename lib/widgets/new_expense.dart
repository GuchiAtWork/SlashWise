import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/notifiers.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';

class NewExpense extends StatefulWidget {
  NewExpense(this.userID, this.group);

  final String userID;
  final DbGroup group;

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  File file;

  void _onSubmit(MultipleNotifier _multipleNotifier, String currUserID) {
    print('+++++++++++++++++++++++++++++++++++++++++');
    final selectedUsers = _multipleNotifier.selectedUsers();

    if (_amountController.text.isEmpty) return;

    final _title = _titleController.text;
    final _amount = int.parse(_amountController.text);

    if (_title.isEmpty || _amount <= 0) return;

    List<String> payees = [];

    if (selectedUsers.length == 0) {
      payees = widget.group.users?.cast<String>();
    } else {
      payees = selectedUsers.map((user) => user.id).toList();
      payees.add(currUserID);
    }

    DatabaseServiceExpense()
        .addExpense(_title, _amount, DateTime.now(), widget.userID,
            widget.group.id, payees)
        .then((expense) {
      if (file != null) {
        DatabaseServiceExpense().uploadReceipt(expense.id, file);
      }
    });

    Navigator.pop(context);
    Navigator.pop(context);
  }

  void pickImage() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    file = File(pickedFile.path);
  }

  void _choicesMembersDialog(BuildContext context, List<User> groupMembers,
      MultipleNotifier _multipleNotifier) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Member to Include'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: groupMembers
                      .map((user) => StatefulBuilder(
                            builder: (context, _setState) => CheckboxListTile(
                              title: Text(user.name),
                              value: _multipleNotifier.isHaveUser(user),
                              onChanged: (value) {
                                _setState(() => value
                                    ? _multipleNotifier.addUser(user)
                                    : _multipleNotifier.removeUser(user));
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void _createConfirmationDialog(BuildContext context,
      MultipleNotifier _multipleNotifier, String currUserID) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text(
                'Please note that after confirmation any modification will not be possible for security reason'),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('Confirm'),
                onPressed: () => _onSubmit(_multipleNotifier, currUserID),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final currUserID = Provider.of<AuthUser>(context).uid;
    final allUsers = Provider.of<List<User>>(context);
    final _multipleNotifier = Provider.of<MultipleNotifier>(context);

    print('**********************');
    final groupMembers = allUsers
        .where((user) =>
            widget.group.users.contains(user.id) && user.id != currUserID)
        .toList();

    print(groupMembers);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _titleController,
                onSubmitted: (_) => _onSubmit(_multipleNotifier, currUserID),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _createConfirmationDialog(
                    context, _multipleNotifier, currUserID),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('Include Only'),
                    onPressed: () => _choicesMembersDialog(
                        context, groupMembers, _multipleNotifier),
                  ),
                  ElevatedButton(
                    child: Text('Add Image'),
                    onPressed: () => pickImage(),
                  ),
                  ElevatedButton(
                    child: Text('Confirm'),
                    onPressed: () => _createConfirmationDialog(
                        context, _multipleNotifier, currUserID),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
