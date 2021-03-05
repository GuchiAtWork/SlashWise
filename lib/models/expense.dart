import 'package:flutter/foundation.dart';

class Expense {
  Expense(this.name, this.amount);

  @required
  String id = DateTime.now().toString();
  @required
  String name;
  @required
  int amount;
  @required
  DateTime date = DateTime.now();
}
