import 'package:flutter/material.dart';
import './models/group.dart';
import './widgets/group_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlashWise',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Group> _groups = [
    Group('ulteam'),
  ];

  void _deleteGroup(String id) {
    _groups.removeWhere((group) => group.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SlashWise'),
      ),
      body: Column(
        children: <Widget>[
          GroupList(_groups, _deleteGroup),
        ],
      ),
    );
  }
}
