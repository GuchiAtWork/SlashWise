import 'package:flutter/foundation.dart';
import 'package:slash_wise/models/user.dart';

class Expense {
  Expense(this.id, this.name, this.amount, this.date, this.payer, this.groupID,
      this.payees);

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
  @required
  String groupID;
  @required
  List<String> payees;
}
