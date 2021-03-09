import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/expense.dart';

class DatabaseServiceExpense {
  // collection reference
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<Expense> addExpense(
      String expenseName, int amount, DateTime date, String payerID) async {
    final createdExpense = await expenseCollection.add({
      "name": expenseName,
      "date": Timestamp.fromDate(date),
      "price": amount,
      "payer": payerID,
    }).then((ref) {
      final expense = Expense(ref.id, expenseName, amount, date, payerID);
      return expense;
    });

    return createdExpense;
  }

  Future<List<Expense>> getExpenses(String groupID) async {
    final List<Expense> groupExpenses = [];

    await expenseCollection
        .where("groupID", isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((expense) {
        final newExpense = Expense(expense.id, expense["name"],
            expense["price"], expense["date"].toDate(), expense["payer"]);
        groupExpenses.add(newExpense);
      });
    });

    return groupExpenses;
  }

  Future<Map<String, num>> calculateExpenses(
      String userID, String groupID) async {
    final Map<String, num> calculatedDebt = {};

    final expenses = await getExpenses(groupID);
    final groupDetails = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get()
        .then((DocumentSnapshot docRef) {
      final caughtGroup = DbGroup(
          docRef.id, docRef["name"], docRef["users"], docRef["date"].toDate());
      return caughtGroup;
    });

    print(groupDetails);

    return calculatedDebt;
  }
}
