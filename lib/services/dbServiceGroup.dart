import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbGroup.dart';

class DatabaseServiceGroup {
  final String uid;
  DatabaseServiceGroup({this.uid});

  //collection reference
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future updateGroupData(String name, Timestamp date) async {
    return await groupCollection.doc(uid).set({
      'name': name,
      'date': date,
    });
  }

  // group list from snapshot
  List<DbGroup> _groupListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DbGroup(
          name: doc.data()['name'] ?? "", date: doc.data()['date'] ?? "");
    }).toList();
  }

  // get groups stream
  Stream<List<DbGroup>> get groups {
    return groupCollection.snapshots().map(_groupListFromSnapshot);
  }
}
