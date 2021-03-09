// import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:slash_wise/models/dbGroup.dart';
// import 'package:slash_wise/models/dbUser.dart';
import 'package:slash_wise/models/group.dart';
// ignore: unused_import
import 'package:slash_wise/screens/home/group_list.dart';
import 'package:slash_wise/services/auth.dart';
// ignore: unused_import
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
    Group("2", 'ulteam', [], [], DateTime.now()),
    Group("3", 'vromvrom', [], [], DateTime.now()),
    Group("4", 'aladin', [], [], DateTime.now()),
    Group("5", 'CC17', [], [], DateTime.now()),
  ];

  void _addNewGroup(String name) {
    final newGroup = Group("1", name, [], [], DateTime.now());

    setState(() {
      _groups.add(newGroup);
    });
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
    return Scaffold(
      body: Text("Test"),
    );
  }
}
