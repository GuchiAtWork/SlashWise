import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/models/user_auth.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

Widget createSettingButton(String settingButtonName, Function action) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: action,
      child: Text(
        settingButtonName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final userAuthID = Provider.of<AuthUser>(context).uid;
    final allUsers = Provider.of<List<User>>(context);

    final currUser = allUsers.firstWhere((user) => user.id == userAuthID);

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              createSettingButton("Change Logo", () {}),
              createSettingButton("Change Email", () {}),
              createSettingButton("Change Username", () {}),
              createSettingButton("Change Password", () {}),
            ],
          ),
        ));
  }
}
