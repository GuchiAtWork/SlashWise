import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';
/*
class DbGroup {
  final String name;
  final Timestamp date;
  DbGroup({this.name, this.date});
}
*/

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
