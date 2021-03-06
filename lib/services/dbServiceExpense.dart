import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/expense.dart';
import 'package:slash_wise/services/dbServiceGroup.dart';
import 'package:slash_wise/services/dbServiceUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DatabaseServiceExpense {
  // collection reference
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');
/*
how to use uploadReceiptURL/getReceiptURL
  import 'package:image_picker/image_picker.dart';
  final picker = ImagePicker();
  final pickedImage = await picker.getImage(source: ImageSource.gallery);
  await DatabaseServiceExpense().uploadReceipt("expenseID", pickedImage);
  final url = await DatabaseServiceExpense().getReceiptURL("expenseID");
*/
  Future<String> uploadReceipt(String expenseID, File img) async {
    await FirebaseStorage.instance.ref('$expenseID').putFile(img);
    String downloadURL =
        await FirebaseStorage.instance.ref('$expenseID').getDownloadURL();
    return downloadURL;
  }

  Future<String> getReceipt(String expenseID) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('$expenseID')
        .getDownloadURL()
        .then((imageURL) {
      return imageURL;
    }).catchError((onError) {
      return "";
    });

    return downloadURL;
  }

  Future<Expense> addExpense(String expenseName, int amount, DateTime date,
      String payerID, String groupID, List<String> payees) async {
    final createdExpense = await expenseCollection.add({
      "name": expenseName,
      "date": Timestamp.fromDate(date),
      "price": amount,
      "payer": payerID,
      "groupID": groupID,
      "payees": payees,
    }).then((ref) {
      final expense =
          Expense(ref.id, expenseName, amount, date, payerID, groupID, payees);
      return expense;
    });

    return createdExpense;
  }

  Stream<List<Expense>> expenses() {
    return expenseCollection.snapshots().map((QuerySnapshot querySnapshot) =>
        querySnapshot.docs
            .map((e) => Expense(
                e.id,
                e.data()['name'],
                e.data()['price'],
                e.data()['date'].toDate(),
                e.data()["payer"],
                e.data()["groupID"],
                e.data()["payees"]?.cast<String>()))
            .toList());
  }

  Future<List<Expense>> getExpenses(String groupID) async {
    final List<Expense> groupExpenses = [];

    await expenseCollection
        .where("groupID", isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((expense) {
        final newExpense = Expense(
            expense.id,
            expense["name"],
            expense["price"],
            expense["date"].toDate(),
            expense["payer"],
            expense["groupID"],
            expense["payees"]?.cast<String>());
        groupExpenses.add(newExpense);
      });
    });
    //print("##########");
    //print(groupExpenses[0].date);
    groupExpenses.sort((a, b) => a.date.compareTo(b.date));

    return groupExpenses;
  }

  Future<Map<String, num>> calculateExpenses(
      String userID, String groupID) async {
    final groupDbInterface = DatabaseServiceGroup();

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
      final curExpense = expenses[j];
      final amount = curExpense.amount;
      final payerID = curExpense.payer;
      final payees = curExpense.payees;
      final splitAmount = amount / payees.length;

      if (payerID == userID) {
        for (int payee = 0; payee < payees.length; payee++) {
          if (payees[payee] != userID) {
            calculatedDebtID[payees[payee]] += splitAmount;
          }
        }
      } else {
        calculatedDebtID[payerID] -= splitAmount;
      }

      // if (payerID == userID) {
      //   calculatedDebtID.forEach((key, _) {
      //     calculatedDebtID[key] += splitAmount;
      //   });
      // } else {
      //   calculatedDebtID[payerID] -= splitAmount;
      // }
    }

    return calculatedDebtID;
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
