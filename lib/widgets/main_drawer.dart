import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class MainDrawer extends StatelessWidget {
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
    return Drawer(
      elevation: 5,
      child: Column(
        children: [
          Container(
            height: 225,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'here is small profile description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue[50],
              child: Column(
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
                    'Donate to Fred',
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
            ),
          ),
        ],
      ),
    );
  }
}
