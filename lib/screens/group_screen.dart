import 'package:flutter/material.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/widgets/new_expense.dart';
import '../dummy_data/group_ulteam.dart';
import 'package:intl/intl.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = '/group';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  // final appUser = ulteam.users.firstWhere((user) => user.name == "keizo");
  // var userExpenses = {};

  // Map<String, num> _calculateExpenses(User appUser) {
  //   Map<String, num> oweTabs = {};
  //   final appUserName = appUser.name;

  //   for (var i = 0; i < ulteam.users.length; i++) {
  //     final userName = ulteam.users[i].name;

  //     if (!(userName == appUserName)) {
  //       oweTabs[userName] = 0;
  //     }
  //   }

  //   for (var j = 0; j < ulteam.expenses.length; j++) {
  //     final payerName = ulteam.expenses[j].payer.name;
  //     final amount = ulteam.expenses[j].amount;
  //     final amountOfPayees = ulteam.expenses[j].payees.length;
  //     final splitAmount = amount / (amountOfPayees + 1);

  //     if (payerName == appUserName) {
  //       oweTabs.forEach((name, _) => {oweTabs[name] += splitAmount});
  //     } else {
  //       oweTabs[payerName] -= splitAmount;
  //     }
  //   }

  //   return oweTabs;
  // }

  // @override
  // void initState() {
  //   userExpenses = _calculateExpenses(appUser);
  //   super.initState();
  // }

  void _showNewExpense(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NewExpense();
        });
  }

  void _createPaymentDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Payment'),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 50),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('RECORD A CASH PAYMENT'),
                    ),
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 50),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('PAYPAL'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                elevation: 6,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Page'),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            label: Text("Pay now!"),
            icon: Icon(Icons.payment),
            onPressed: () => _createPaymentDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 254, 229, 1),
              border: Border.all(color: Colors.grey),
            ),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://googleflutter.com/sample_image.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
                Text(
                  'Ul\'team',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Created on Mars 1, 2021'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              //height: 300,
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return Card(
                    elevation: 6,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text(
                                'Picture',
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          ulteam.users[index].name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '\$20',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: ulteam.users.length,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewExpense(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
