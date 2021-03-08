import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Group {
  Group(this.name, this.users, this.expenses);
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
