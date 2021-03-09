import "package:flutter/material.dart";
import 'package:slash_wise/models/dbUser.dart';
import 'package:slash_wise/models/group.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/services/database.dart';
import 'package:slash_wise/widgets/group_list.dart';
import 'package:slash_wise/widgets/main_drawer.dart';
import 'package:slash_wise/widgets/new_group.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final List<Group> _groups = [
    Group('ulteam', [], []),
    Group('vromvrom', [], []),
    Group('aladin', [], []),
    Group('CC17', [], []),
  ];

  void _addNewGroup(String name) {
    final newGroup = Group(name, [], []);

    setState(() {
      _groups.add(newGroup);
    });
  }

  void _showAddNewGroup(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewGroup(_addNewGroup);
      },
    );
  }

  void _deleteGroup(String id) {
    setState(() {
      _groups.removeWhere((group) => group.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<DbUser>>.value(
      initialData: [],
      value: DatabaseService().users,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(title: Text("SlashWise"), actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            icon: Icon(Icons.person),
            label: Text("Logout"),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ]),
        drawer: MainDrawer(),
        body: GroupList(_groups, _deleteGroup),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {_showAddNewGroup(context)},
        ),
      ),
    );
  }
}
