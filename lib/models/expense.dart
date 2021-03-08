import 'package:flutter/foundation.dart';
import 'package:slash_wise/models/user.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Expense {
  Expense(this.name, this.amount, this.payer, this.payees);

  @required
  String id = uuid.v4();
  @required
  String name;
  @required
  int amount;
  @required
  DateTime date = DateTime.now();
  @required
  User payer;
  @required
  List<User> payees;
}
