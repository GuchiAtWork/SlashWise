import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';

class Group {
  Group(this.name);
  @required
  String id = DateTime.now().toString();
  @required
  String name;
  @required
  List<User> users;
  @required
  List<Expense> expenses;
  @required
  DateTime date = DateTime.now();
}
