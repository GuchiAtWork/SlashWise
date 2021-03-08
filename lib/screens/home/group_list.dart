import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:provider/provider.dart";
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/screens/home/group_tile.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    //var users = [];
    final groups = Provider.of<List<DbGroup>>(context);

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return GroupTile(group: groups[index]);
      },
    );
  }
}
