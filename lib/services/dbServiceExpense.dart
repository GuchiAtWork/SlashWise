import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/expense.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
import 'package:slash_wise/services/dbServiceUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseServiceExpense {
  // collection reference
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> upload() async {
    //final picker = ImagePicker();
    //final pickedImage = await picker.getImage(source: ImageSource.gallery);
    //String fileName = pickedImage.path;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDocDir.absolute}/orange.jpg";
    print("########");
    print(appDocDir.path);
    final File img = File(filePath);
    await FirebaseStorage.instance.ref('testes/test.png').putFile(img);
    //UploadTask task = ref.putFile(img);
    //TaskSnapshot snapshot = await task.
  }

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
    final groupDbInterface = DatabaseServiceGroup();
    final userDbInterface = DatabaseServiceUser();

    final Map<String, num> calculatedDebtID = {};

    final expenses = await getExpenses(groupID);
    final groupDetails = await groupDbInterface.getGroup(groupID);
    final amountOfMembers = groupDetails.users.length;

    for (var i = 0; i < amountOfMembers; i++) {
      final curUserID = groupDetails.users[i];

      if (curUserID != userID) {
        calculatedDebtID[curUserID] = 0;
      }
    }

    for (var j = 0; j < expenses.length; j++) {
      final amount = expenses[j].amount;
      final payerID = expenses[j].payer;
      final splitAmount = amount / amountOfMembers;

      if (payerID == userID) {
        calculatedDebtID.forEach((key, _) {
          calculatedDebtID[key] += splitAmount;
        });
      } else {
        calculatedDebtID[payerID] -= splitAmount;
      }
    }

    final Map<String, num> calculatedDebtName = {};

    for (var key in calculatedDebtID.keys) {
      final user = await userDbInterface.getUser(key);
      calculatedDebtName[user.name] = calculatedDebtID[key];
    }

    return calculatedDebtName;
  }

  Future<void> deleteExpense(String expenseID) async {
    await expenseCollection.doc(expenseID).delete();
  }

  Future<void> updateExpense(
      String expenseID, String expenseName, int amount) async {
    await expenseCollection
        .doc(expenseID)
        .update({'name': expenseName, 'price': amount});
  }
}
