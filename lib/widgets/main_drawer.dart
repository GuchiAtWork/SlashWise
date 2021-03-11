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
  Widget build(BuildContext context) {
    final user = Provider.of<AuthUser>(context);
    _getUsername(user.uid);

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
                            'https://googleflutter.com/sample_image.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _userInfo.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _userInfo.email,
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
                () {},
              ),
              buildListTile(
                'Settings',
                Icons.settings,
                () {},
              ),
              buildListTile(
                'Scan code',
                Icons.qr_code_scanner,
                () {},
              ),
              buildListTile(
                'Rate me',
                Icons.rate_review,
                () {},
              ),
              buildListTile(
                'Contact us',
                Icons.mail,
                () {},
              ),
              buildListTile(
                'Donate',
                Icons.attach_money,
                () {},
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
