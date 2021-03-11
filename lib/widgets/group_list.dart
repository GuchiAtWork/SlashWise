import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user_auth.dart';

class GroupList extends StatefulWidget {
  GroupList(this._groupList, this._deleteGroup);
  final List<DbGroup> _groupList;
  final Function _deleteGroup;

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: widget._groupList.isEmpty
          ? Column(
              children: <Widget>[Text('No Group added yet!')],
            )
          : ListView.builder(
              itemBuilder: (_, index) {
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text('Picture'),
                    ),
                    title: Text(widget._groupList[index].name),
                    subtitle: Text(
                      DateFormat.yMMMd().format(widget._groupList[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Theme.of(context).errorColor,
                      //onPressed: () => _deleteGroup(widget._groupList[index].id),
                    ),
                    onLongPress: () {},
                  ),
                );
              },
              itemCount: widget._groupList.length,
            ),
    );
  }
}
