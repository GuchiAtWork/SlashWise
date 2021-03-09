import 'package:slash_wise/models/expense.dart';
import 'package:slash_wise/models/group.dart';
import 'package:slash_wise/models/user.dart';

var keizo = User("1", 'keizo');
var fred = User("2", 'Fred');
var hiroki = User("3", 'hiroki');
var nahoko = User("4", 'nahoko');

List<User> members = [keizo, fred, hiroki, nahoko];

var expense1 = Expense("1", "Travelling", 50, DateTime.now(), "1");
var expense2 = Expense("2", "Eating", 100, DateTime.now(), "2");
var expense3 = Expense("3", "Taxi", 200, DateTime.now(), "3");

// fred = +12.5, hiroki = +12.5, nahoko = +12.5
// fred = +12.5, hiroki = -20.8333, nahoko = +12.5
// fred = +12.5, hiroki = -20.8333, nahoko = -54.1667

List<Expense> expenses = [expense1, expense2, expense3];

Group ulteam = Group("1", 'ulteam', members, expenses, DateTime.now());
