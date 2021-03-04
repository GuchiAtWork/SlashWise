import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbUser.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String email, int age) async {
    return await userCollection.document(uid).setData({
      'email': email,
      'age': age,
    });
  }

  // user list from snapshot
  List<DbUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return DbUser(
        email: doc.data['email'] ?? "",
        age: doc.data['age'] ?? 0,
      );
    }).toList();
  }

  // get users stream
  Stream<List<DbUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}