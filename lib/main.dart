import 'package:flutter/material.dart';
import './models/group.dart';
import './widgets/group_list.dart';
import 'widgets/new_group.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlashWise',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Group> _groups = [
    Group('ulteam'),
    Group('vromvrom'),
    Group('aladin'),
    Group('CC17')
  ];

  void _addNewGroup(String name) {
    final newGroup = Group(name);

    setState(() {
      _groups.add(newGroup);
    });
  }

  void _showAddNewGroup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewGroup(_addNewGroup);
      },
    );
  }

  void _deleteGroup(String id) {
    setState(() {
      _groups.removeWhere((group) => group.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SlashWise'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          GroupList(_groups, _deleteGroup),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {_showAddNewGroup(context)},
      ),
    );
  }
}
