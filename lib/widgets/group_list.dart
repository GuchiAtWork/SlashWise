import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';

class GroupList extends StatelessWidget {
  final groupDatabase = DatabaseServiceGroup();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);

    return FutureBuilder(
      future: groupDatabase.getGroups(user.uid),
      builder: (BuildContext context, AsyncSnapshot<List<DbGroup>> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 600,
            child: snapshot.data.isEmpty
                ? Column(
                    children: <Widget>[Text('No Group added yet!')],
                  )
                : ListView.builder(
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 6,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Text('Picture'),
                          ),
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(
                            DateFormat.yMMMd()
                                .format(snapshot.data[index].date),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.delete_forever),
                              color: Theme.of(context).errorColor,
                              onPressed: () =>
                                  //_deleteGroup(snapshot.data[index].id),
                                  () {}),
                          onTap: () => Navigator.pushNamed(
                              context, GroupScreen.routeName),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
