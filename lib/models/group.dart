import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/user.dart';


class Group {
  Group(this.id, this.name, this.users, this.expenses, this.date);
  @required
  String id;
  @required
  String name;
  @required
  List<User> users;
  @required
  List<Expense> expenses;
  @required
  DateTime date;
}
