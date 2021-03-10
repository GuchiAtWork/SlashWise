import 'package:flutter/material.dart';

class DbGroup {
  DbGroup(this.id, this.name, this.users, this.date);
  @required
  String id;
  @required
  String name;
  @required
  List<String> users;
  @required
  DateTime date;
}
