import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbUser.dart';

class DatabaseServiceUser {
  final String uid;
  DatabaseServiceUser({this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection('users'); //Firestore => FirebaseFirestore

  Future updateUserData(String email, int age) async {
    return await userCollection.doc(uid).set({
      //document => doc, setData => set
      'email': email,
      'age': age,
    });
  }

  // user list from snapshot
  List<DbUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //documents => docs
      //print(doc.data()['email']);
      return DbUser(
        email: doc.data()['email'] ?? "",
        //age: doc.data['age'] ?? 0,
      );
    }).toList();
  }

  // get users stream
  Stream<List<DbUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
