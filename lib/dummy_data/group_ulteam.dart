import 'dart:math';

import 'package:slash_wise/models/expense.dart';
import 'package:slash_wise/models/group.dart';
import 'package:slash_wise/models/user.dart';

var keizo = User('keizo');
var fred = User('Fred');
var hiroki = User('hiroki');
var nahoko = User('nahoko');

List<User> members = [keizo, fred, hiroki, nahoko];

var expense1 = Expense("Travelling", 50, keizo, [fred, hiroki, nahoko]);
var expense2 = Expense("Eating", 100, hiroki, [keizo, fred]);
var expense3 = Expense("Taxi", 200, nahoko, [keizo, fred]);

// fred = +12.5, hiroki = +12.5, nahoko = +12.5
// fred = +12.5, hiroki = -20.8333, nahoko = +12.5
// fred = +12.5, hiroki = -20.8333, nahoko = -54.1667

List<Expense> expenses = [expense1, expense2, expense3];

Group ulteam = Group('ulteam', members, expenses);
