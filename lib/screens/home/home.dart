// import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:slash_wise/models/dbGroup.dart';
// import 'package:slash_wise/models/dbUser.dart';
import 'package:slash_wise/models/group.dart';
import 'package:slash_wise/screens/home/group_list.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
//import 'package:slash_wise/widgets/group_list.dart';
import 'package:slash_wise/widgets/new_group.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final List<Group> _groups = [
    Group('ulteam'),
    Group('vromvrom'),
    Group('aladin'),
    Group('CC17')
  ];

  void _addNewGroup(String name) {
    // final newGroup = Group(name);
    var task = <String, dynamic>{
      "name": name,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };
    DatabaseServiceGroup.updateGroupData(task);
    // setState(() {
    //   _groups.add(newGroup);
    // });
  }

  // Display Add Task Dialog
  void _showAddNewGroup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewGroup(_addNewGroup);
      },
    );
  }

  // void _deleteGroup(String id) {
  //   setState(() {
  //     _groups.removeWhere((group) => group.id == id);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return StreamProvider<List<DbGroup>>.value(
      initialData: List(),
      value: DatabaseServiceGroup().groups,
=======
    return StreamProvider<List<DbUser>>.value(
      //initialData: List(),
      value: DatabaseService().users,
>>>>>>> bbb78ccf14e22e57d9cbb82210ad60de03be48cd
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
            title: Text("SlashWise"),
            backgroundColor: Colors.blue[400],
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text("Logout"),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ]),
        body: GroupList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
            //_showAddNewGroup(context)
            showModalBottomSheet(
              context: context,
              builder: (context) => {
                return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'name',
                icon: Icon(Icons.group_add),
              ),
            ),
            ElevatedButton(
              child: Text('Add Group'),
              onPressed: () => Text("test"),
            )
  };
            )
          },
        ),
      ),
    );
  }
}
