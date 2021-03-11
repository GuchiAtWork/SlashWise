import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/services/dbServiceUser.dart';
import 'package:slash_wise/widgets/new_expense.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = '/group';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

var ulteam = [];

class _GroupScreenState extends State<GroupScreen> {
  final userDatabase = DatabaseServiceUser();

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

  // forEach

  // DbGroup -> List of User ids -> Send all user ids to backend using the getUser method 8
  List<User> _getListUsers(DbGroup group) {
    // List<String> usersIds = group.users;

    // usersIds.forEach((userUid, Function fn ) {
    //   await fn.getUsers(userUid)
    // });
  }

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context).settings.arguments as DbGroup;
    getListUsers(group);

    return Scaffold(
      appBar: AppBar(
        title: Text('GroupDetails'),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.black,
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
            color: Theme.of(context).colorScheme.background,
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
                  group.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(DateFormat.yMMMd().format(group.date)),
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
                          ulteam[index].name, // TODO add a team
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
                itemCount: ulteam.length, // TODO add a team
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
