import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/services/dbServiceUser.dart';
import "package:slash_wise/models/user.dart" as UserModel;

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _userDatabase = DatabaseServiceUser();
  UserModel.User _userInfo = UserModel.User("", "", "");

  _getUsername(uid) {
    _userDatabase.getUser(uid).then((user) => setState(() {
          print('setState() called 3');
          _userInfo = user;
        }));
  }

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  void didChangeDependencies() {
    final user = Provider.of<AuthUser>(context);
    _getUsername(user.uid);
    super.didChangeDependencies();
  }

  void _createWipDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Work In Progress'),
            content: Text('Please Come Back Later!'),
            actions: [
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://thumbs.dreamstime.com/b/default-avatar-profile-flat-icon-social-media-user-vector-portrait-unknown-human-image-default-avatar-profile-flat-icon-184330869.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _userInfo.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
                Text(
                  _userInfo.email,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              buildListTile(
                'Home',
                Icons.home,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Settings',
                Icons.settings,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Scan code',
                Icons.qr_code_scanner,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Rate me',
                Icons.rate_review,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Contact us',
                Icons.mail,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Donate',
                Icons.attach_money,
                () => _createWipDialog(context),
              ),
              buildListTile(
                'Log out',
                Icons.logout,
                () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
