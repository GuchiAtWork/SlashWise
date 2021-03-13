import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/notifiers.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';

class NewExpense extends StatefulWidget {
  NewExpense(this.userID, this.groupID);

  final String userID;
  final String groupID;

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _onSubmit() {
    if (_amountController.text.isEmpty) return;

    final _title = _titleController.text;
    final _amount = int.parse(_amountController.text);

    if (_title.isEmpty || _amount <= 0) return;

    DatabaseServiceExpense().addExpense(
        _title, _amount, DateTime.now(), widget.userID, widget.groupID);

    Navigator.pop(context);
  }

  void _choicesMembersDialog(BuildContext context, List<User> allUsers,
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
                  children: allUsers
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

  @override
  Widget build(BuildContext context) {
    final allUsers = Provider.of<List<User>>(context);
    final _multipleNotifier = Provider.of<MultipleNotifier>(context);
    _multipleNotifier.selectedUsers();

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
                onSubmitted: (_) => _onSubmit(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _onSubmit(),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('Include Only'),
                    onPressed: () => _choicesMembersDialog(
                        context, allUsers, _multipleNotifier),
                  ),
                  ElevatedButton(
                    child: Text('Add Expense'),
                    onPressed: _onSubmit,
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
