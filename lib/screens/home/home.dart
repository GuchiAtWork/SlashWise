import 'dart:io';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
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

  void _addNewGroup(String newGroupName, String userID, File file) async {
    final addedGroup =
        await groupDatabase.addGroup(userID, newGroupName, DateTime.now());

    if (file != null) {
      groupDatabase.uploadGroupIcon(addedGroup.id, file);
    }
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
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    // return Stack(children: <Widget>[
    //   Image.asset(
    //     "assets/signin.jpeg",
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     fit: BoxFit.cover,
    //   ),
    return Scaffold(
      //backgroundColor: Colors.transparent,
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontFamily: 'Anton'),
        ),
      ),
      drawer: MainDrawer(),
      body: GroupList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group_add),
        onPressed: () => {_showAddNewGroup(context, user.uid)},
      ),
    );
    //]);
  }
}
