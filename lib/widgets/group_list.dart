import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group.dart';

class GroupList extends StatelessWidget {
  final List<Group> _groups;
  final Function _deleteGroup;

  GroupList(this._groups, this._deleteGroup);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: _groups.isEmpty
          ? Column(
              children: <Widget>[Text('No Group added yet!')],
            )
          : ListView.builder(
              itemBuilder: (_, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text('Picture'),
                    ),
                    title: Text(_groups[index].name),
                    subtitle: Text(
                      DateFormat.yMMMd().format(_groups[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Theme.of(context).errorColor,
                      onPressed: _deleteGroup,
                    ),
                  ),
                );
              },
              itemCount: _groups.length,
            ),
    );
  }
}
