import 'package:flutter/foundation.dart';
import 'package:slash_wise/models/user.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Expense {
  Expense(this.id, this.name, this.amount, this.date, this.payer);

  @required
  String id;
  @required
  String name;
  @required
  int amount;
  @required
  DateTime date;
  @required
  String payer;
}
