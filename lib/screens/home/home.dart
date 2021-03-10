import "package:flutter/material.dart";
import 'package:slash_wise/services/auth.dart';
import 'package:slash_wise/widgets/group_list.dart';
import 'package:slash_wise/widgets/main_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
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
      body: GroupList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}
