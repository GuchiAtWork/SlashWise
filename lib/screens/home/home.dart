import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:slash_wise/models/dbUser.dart';
import 'package:slash_wise/screens/home/user_list.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slash_wise/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<DbUser>>.value(
      initialData: List(),
      value: DatabaseService().users,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
            title: Text("SlashWise"),
            backgroundColor: Colors.blue[400],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text("logout"),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ]),
        body: UserList(),
      ),
    );
  }
}
