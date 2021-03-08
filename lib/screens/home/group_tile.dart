import "package:flutter/material.dart";
import 'package:slash_wise/models/dbGroup.dart';

class GroupTile extends StatelessWidget {
  final DbGroup group;
  GroupTile({this.group});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
            child: ListTile(
              title: Text(group.name),
              subtitle: Text("group was created on: ${group.date}"),
            )));
  }
}
