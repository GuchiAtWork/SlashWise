import "package:flutter/material.dart";
import 'package:slash_wise/models/dbUser.dart';

class UserTile extends StatelessWidget {
  final DbUser user;
  UserTile({this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
            child: ListTile(
              title: Text(user.email),
              subtitle: Text("User is ${user.age} years old"),
            )));
  }
}
