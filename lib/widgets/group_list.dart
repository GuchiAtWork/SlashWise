import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  final groupDatabase = DatabaseServiceGroup();

  //await groupDatabase.getGroups(user.uid);

  List<DbGroup> _groupList = [];

  _getGroupList(uid) {
    groupDatabase.getGroups(uid).then((value) => setState(() {
          _groupList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    _getGroupList(user.uid);

    return Container(
      height: 600,
      child: _groupList.isEmpty
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
                    title: Text(_groupList[index].name),
                    subtitle: Text(
                      DateFormat.yMMMd().format(_groupList[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Theme.of(context).errorColor,
                      //onPressed: () => _deleteGroup(_groupList[index].id),
                    ),
                    onLongPress: () {},
                  ),
                );
              },
              itemCount: _groupList.length,
            ),
    );
  }
}
