import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Expense {
  Expense(this.name, this.amount);

  @required
  String id = uuid.v4();
  @required
  String name;
  @required
  int amount;
  @required
  DateTime date = DateTime.now();
}
