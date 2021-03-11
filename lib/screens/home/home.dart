import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:slash_wise/widgets/group_list.dart';
import 'package:slash_wise/widgets/main_drawer.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
import 'package:slash_wise/widgets/new_group.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final groupDatabase = DatabaseServiceGroup();

  List<DbGroup> _groupList = [];

  _getGroupList(uid) {
    groupDatabase.getGroups(uid).then((value) => setState(() {
          _groupList = value;
          print('setState called()');
        }));
  }

  _addNewGroup(String newGroupName, String userID) {
    groupDatabase
        .addGroup(userID, newGroupName, DateTime.now())
        .then((newGroup) {
      setState(() {
        print('setState called()');
        _groupList.add(newGroup);
      });
    });
  }

  _deleteGroup(int groupIndex) {
    groupDatabase
        .deleteGroup(_groupList[groupIndex].id)
        .then((_) => setState(() {
              print('setState called()');
              _groupList.removeAt(groupIndex);
            }));
  }

  void _showAddNewGroup(BuildContext context, String userID) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return NewGroup(_addNewGroup, userID);
        });
  }

  @override
  void didChangeDependencies() {
    final user = Provider.of<AuthUser>(context);
    _getGroupList(user.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    //_getGroupList(user.uid);

    return Scaffold(
      appBar: AppBar(title: Text("SlashWise"), actions: <Widget>[
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
          icon: Icon(Icons.person),
          label: Text("Logout"),
          onPressed: () async {
            await _auth.signOut();
          },
        )
      ]),
      drawer: MainDrawer(),
      body: GroupList(_groupList, _deleteGroup),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {_showAddNewGroup(context, user.uid)},
      ),
    );
  }
}
