import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/user.dart';

var uuid = Uuid();

class Group {
  Group(this.name);
  @required
  String id = uuid.v4();
  @required
  String name;
  @required
  List<User> users;
  @required
  List<Expense> expenses;
  @required
  DateTime date = DateTime.now();
}
