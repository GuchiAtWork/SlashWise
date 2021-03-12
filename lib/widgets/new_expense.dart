import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/expense.dart';
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
              ElevatedButton(
                child: Text('Add Expense'),
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
