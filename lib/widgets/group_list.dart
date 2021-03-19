import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  final groupDatabase = DatabaseServiceGroup();

  _deleteGroup(String groupID, String currUserID) {
    groupDatabase.removeMemberFromGroup(groupID, currUserID);
  }

  Future<String> returnGroupImage(String groupID) {
    final urlString = groupDatabase.getGroupIcon(groupID);
    return urlString;
  }

  @override
  Widget build(BuildContext context) {
    List<DbGroup> groupList = Provider.of<List<DbGroup>>(context);
    final authUser = Provider.of<AuthUser>(context);

    var filteredGroupList =
        groupList.where((group) => group.users.contains(authUser.uid)).toList();

    return Container(
      height: 600,
      child: (filteredGroupList.isEmpty)
          ? Center(
              child: Text(
                'LOADING...',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemBuilder: (_, index) {
                return FutureBuilder(
                    future: returnGroupImage(filteredGroupList[index].id),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? Card(
                              color: Colors.indigo[100],
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    snapshot.data,
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                ),
                                title: Text(
                                  filteredGroupList[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  'Created on: ${DateFormat.yMMMd().format(filteredGroupList[index].date)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Quit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).errorColor),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.logout),
                                        color: Theme.of(context).errorColor,
                                        onPressed: () async {
                                          if (await confirm(context,
                                              content: Text(
                                                  'Would you like to Leave this group?'))) {
                                            return _deleteGroup(
                                                filteredGroupList[index].id,
                                                authUser.uid);
                                          }
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, GroupScreen.routeName,
                                      arguments: filteredGroupList[index]);
                                },
                              ),
                            )
                          : Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    "https://he.cecollaboratory.com/public/layouts/images/group-default-logo.png",
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                ),
                                title: Text(filteredGroupList[index].name),
                                subtitle: Text(
                                  DateFormat.yMMMd()
                                      .format(filteredGroupList[index].date),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.exit_to_app),
                                    color: Theme.of(context).errorColor,
                                    //onPressed: () => _deleteGroup(
                                    //  filteredGroupList[index].id,
                                    //authUser.uid),
                                    onPressed: () async {
                                      if (await confirm(context,
                                          content: Text(
                                              'Would you like to remove this group?'))) {
                                        return _deleteGroup(
                                            filteredGroupList[index].id,
                                            authUser.uid);
                                      }
                                    }),
                                onTap: () {
                                  // pass to the GroupScreen _groupList[index]
                                  Navigator.pushNamed(
                                      context, GroupScreen.routeName,
                                      arguments: filteredGroupList[index]);
                                },
                              ),
                            );
                    });
              },
              itemCount: filteredGroupList.length,
            ),
    );
  }
}
