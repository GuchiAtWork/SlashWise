import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/expense.dart';
import 'package:slash_wise/models/notifiers.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
import 'package:slash_wise/services/dbServiceUser.dart';
import 'package:slash_wise/widgets/new_expense.dart';
import 'package:slash_wise/screens/paymentscreen.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = '/group';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

List<User> team = [];
Map<String, num> owe = {};

class _GroupScreenState extends State<GroupScreen> {
  final expenseDatabase = DatabaseServiceExpense();
  final userDatabase = DatabaseServiceUser();
  final groupDatabase = DatabaseServiceGroup();
  final _emailController = TextEditingController();

  String groupImageURL =
      "https://he.cecollaboratory.com/public/layouts/images/group-default-logo.png";

  String _showUsernameByID(String userID) {
    String username = "";

    for (int i = 0; i < team.length; i++) {
      if (team[i].id == userID) {
        username = team[i].name;
      }
    }

    return username;
  }

  void _showNewExpense(BuildContext context, String userID, DbGroup group) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return NewExpense(userID, group);
        });
  }

  Widget generalPayment(BuildContext context, String currUserID, String groupID,
      List<User> usersToOwe) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Confirm Your Payment'),
            content: Text('Pay back everyone'),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () {
                  for (int i = 0; i < usersToOwe.length; i++) {
                    List<String> payees = [];
                    payees.add(usersToOwe[i].id);

                    expenseDatabase.addExpense(
                        'Pay back ${usersToOwe[i].name}',
                        owe[usersToOwe[i].id].toInt().abs(),
                        DateTime.now(),
                        currUserID,
                        groupID,
                        payees);
                  }

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _generalPaymentDialog(
      BuildContext context, String currUserID, String groupID) {
    num allAmounts = 0;
    bool flag = false;

    owe.forEach((_, num amount) {
      if (amount < 0) flag = true;
      allAmounts += amount;
    });
    print(allAmounts);

    List<User> usersToOwe = team.where((user) {
      if (owe[user.id] < 0) {
        return true;
      } else {
        return false;
      }
    }).toList();

    showDialog(
        context: context,
        builder: (_) {
          return flag
              ? AlertDialog(
                  title: Text('Pay Back to Everyone:'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text('Record Cash Payment'),
                          onPressed: () {
                            generalPayment(
                                context, currUserID, groupID, usersToOwe);
                          }, // TODO make the payment function
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('You don\'t owe money to anyone.'),
                  actions: [
                    ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
        });
  }

  Widget singlePayment(BuildContext context, String currUserID, User payee,
      num amount, String groupID) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Confirm Your Payment'),
            content:
                Text('Pay ${payee.name} ¥${amount.abs().toStringAsFixed(0)}'),
            actions: [
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () {
                  List<String> payees = [];
                  payees.add(payee.id);

                  expenseDatabase.addExpense(
                      'Pay back ${payee.name}',
                      //-(amount.count()),
                      amount.toInt().abs(),
                      DateTime.now(),
                      currUserID,
                      groupID,
                      payees);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _singlePaymentDialog(BuildContext context, User currUser, User payee,
      num amount, String groupID) {
    showDialog(
        context: context,
        builder: (_) {
          return amount < 0
              ? AlertDialog(
                  title: Text('Choose an option:'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text('Record Cash Payment'),
                          onPressed: () => singlePayment(
                              context,
                              currUser.id,
                              payee,
                              amount,
                              groupID), // TODO make the payment function
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Text('Pay With PayPal'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                        currUser,
                                        payee,
                                        amount.toInt().abs(),
                                        groupID) // TODO make the param static => dynamic
                                    ));
                          }, // TODO make the payment function
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text('You don\'t owe money.'),
                  actions: [
                    ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ); //second dialogue here
        });
  }

  void _submitData(String groupID, MultipleNotifier _multipleNotifier) async {
    if (_emailController.text.isEmpty) return;
    final enteredEmail = _emailController.text;
    var result = 'User doesn\'t exist';

    var userToAdd = await DatabaseServiceUser().getUserByEmail(enteredEmail);
    if (userToAdd != null) {
      result = 'User successfully added';
      DatabaseServiceGroup().addMemberToGroup(groupID, enteredEmail);
      setState(() {
        print('setState() called when add a member');
        team.add(userToAdd);
        _multipleNotifier.addUser(userToAdd);

        print(team);
      });
    }
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        action: SnackBarAction(label: 'Clear', onPressed: () {}),
      ),
    );
  }

  void _createAddMemberDialog(BuildContext context, String groupID,
      MultipleNotifier _multipleNotifier) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Add a new member:'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Email address',
                icon: Icon(Icons.group_add),
              ),
              controller: _emailController,
              onSubmitted: (_) => () {
                _submitData(groupID, _multipleNotifier);
              },
            ),
            actions: [
              ElevatedButton(
                child: Text('Done'),
                onPressed: () => _submitData(groupID, _multipleNotifier),
              ),
            ],
          );
        });
  }

  // forEach

  // DbGroup -> List of User ids -> Send all user ids to backend using the getUser method 8
  void _getListUsers(DbGroup group, String currUserID) {
    userDatabase.getUsers(group.users).then((value) => setState(() {
          print('setState called() 1');
          var filteredList =
              value.where((user) => user.id != currUserID).toList();

          team = filteredList;
          print(team);
        }));
  }

  void _getOtherExpenses(String userID, String groupID) {
    expenseDatabase
        .calculateExpenses(userID, groupID)
        .then((owes) => setState(() {
              print('setState called() 2');
              owe = owes;
            }));
  }

  @override
  void didChangeDependencies() {
    var userID = Provider.of<AuthUser>(context).uid;
    var group = ModalRoute.of(context).settings.arguments as DbGroup;
    final allGroup = Provider.of<List<DbGroup>>(context);

    group = allGroup.firstWhere((oneGroup) => oneGroup.id == group.id);

    returnGroupImage(group.id);
    _getOtherExpenses(userID, group.id);
    _getListUsers(group, userID);
    super.didChangeDependencies();
  }

  Future<String> returnUserImage(String user) async {
    final urlString = await userDatabase.getUserIcon(user);
    return urlString;
  }

  Future<void> returnGroupImage(String groupID) async {
    final urlString = await groupDatabase.getGroupIcon(groupID);
    setState(() {
      print("setState() 6 CALLED");
      groupImageURL = urlString;
    });
  }

  void _showReceipt(String expenseID) {
    showDialog(
        context: context,
        builder: (_) {
          return FutureBuilder(
            future: expenseDatabase.getReceipt(expenseID),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == "") {
                  return AlertDialog(
                    title: Text("Receipt"),
                    content: SingleChildScrollView(
                      child: Container(
                        child: Center(
                          child: Text('No Receipt Found'),
                        ),
                      ),
                    ),
                  );
                } else {
                  return AlertDialog(
                    title: Text('Receipt'),
                    content: SingleChildScrollView(
                      child: Container(
                        child: Image.network(snapshot.data),
                      ),
                    ),
                  );
                }
              } else {
                return AlertDialog(
                  title: Text('Receipt'),
                  content: SingleChildScrollView(
                    child: Container(
                      child: Center(
                        child: Text('LOADING!'),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<AuthUser>(context).uid;
    final defaultGroup = ModalRoute.of(context).settings.arguments as DbGroup;
    final groupId = defaultGroup.id;
    var group = defaultGroup;

    DatabaseServiceGroup().getGroup(groupId).then((value) => group = value);

    final _multipleNotifier = Provider.of<MultipleNotifier>(context);

    // All expenses from the database - NEEDS TO BE FILTERED
    final allExpenses = Provider.of<List<Expense>>(context);

    final allUsers = Provider.of<List<User>>(context);
    final currUser =
        allUsers.firstWhere((user) => user.id == userID, orElse: () => null);

    // Expenses made by group
    var filteredExpenses =
        allExpenses.where((expense) => expense.groupID == group.id).toList();

    filteredExpenses.sort((a, b) => a.date.compareTo(b.date));
    filteredExpenses = filteredExpenses.reversed.toList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Details'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () =>
                  _createAddMemberDialog(context, group.id, _multipleNotifier),
            ),
            IconButton(
              icon: Icon(Icons.attach_money),
              onPressed: () => _generalPaymentDialog(context, userID, group.id),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Transactions'),
            ],
          ),
        ),
        body: TabBarView(children: [
          // First page *********************************=>
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/signin.jpeg'), fit :BoxFit.cover),
                ),
                height: 185,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ClipOval(
                      child: Image.network(
                        groupImageURL,
                        fit: BoxFit.cover,
                        width: 90.0,
                        height: 90.0,
                      ),
                    ),
                    Text(
                      group.name,
                      style:
                          TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat.yMMMd().format(group.date),
                      style:
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                            ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: team.length > 0
                    ? Container(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return FutureBuilder(
                                future: returnUserImage(team[index].id),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return snapshot.connectionState ==
                                          ConnectionState.done
                                      ? Card(
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: ListTile(
                                              leading: ClipOval(
                                                child: Image.network(
                                                  snapshot.data,
                                                  fit: BoxFit.cover,
                                                  width: 60.0,
                                                  height: 60.0,
                                                ),
                                              ),
                                              title: Text(
                                                team[index].name,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  owe[team[index].id] != null
                                                      ? owe[team[index].id] < 0
                                                          ? Text(
                                                              '¥ ${owe[team[index].id].abs().toStringAsFixed(0)}',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .errorColor),
                                                            )
                                                          : Text(
                                                              '¥ ${owe[team[index].id].toStringAsFixed(0)}',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                      : Text(
                                                          '¥ \$0',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor),
                                                        ),
                                                  IconButton(
                                                    icon: Icon(Icons.navigate_next),
                                                    onPressed: () =>
                                                        _singlePaymentDialog(
                                                            context,
                                                            currUser,
                                                            team[index],
                                                            owe[team[index].id],
                                                            group.id),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Card(
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: ListTile(
                                              leading: Text('LOADING!'),
                                              title: Text(
                                                team[index].name,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  owe[team[index].id] != null
                                                      ? owe[team[index].id] < 0
                                                          ? Text(
                                                              '¥ ${owe[team[index].id].abs().toStringAsFixed(0)}',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .errorColor),
                                                            )
                                                          : Text(
                                                              '¥ ${owe[team[index].id].toStringAsFixed(0)}',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                      : Text(
                                                          '¥ \$0',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .errorColor),
                                                        ),
                                                  IconButton(
                                                    icon: Icon(Icons.navigate_next),
                                                    onPressed: () =>
                                                        _singlePaymentDialog(
                                                            context,
                                                            currUser,
                                                            team[index],
                                                            owe[team[index].id],
                                                            group.id),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                });
                          },
                          itemCount: team.length,
                        ),
                      )
                    : Center(
                        child: Text(
                          'No Members Added Yet!',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
              )
            ],
          ),
          // Second page ********************************=>
          Expanded(
            child: filteredExpenses.length > 0
                ? Container(
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 4,
                          //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              onTap: () =>
                                  _showReceipt(filteredExpenses[index].id),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/money.png',
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                filteredExpenses[index].name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(_showUsernameByID(
                                          filteredExpenses[index].payer) ==
                                      ''
                                  ? 'Remunerator: You'
                                  : 'Remunerator: ${_showUsernameByID(filteredExpenses[index].payer)}'),
                              trailing: Text(
                                '\¥ ${filteredExpenses[index].amount}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: filteredExpenses.length,
                    ),
                  )
                : Center(
                    child: Text(
                      'No Transactions Yet',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNewExpense(context, userID, group),
          child: Icon(Icons.add), // Add a member to the team
        ),
      ),
    );
  }
}
