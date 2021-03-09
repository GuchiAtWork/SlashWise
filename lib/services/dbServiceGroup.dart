import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/models/group.dart';

// RFHPJcUFxcf0q5BqxHGiG2UooT63

class DatabaseServiceGroup {
  //collection reference
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future<List<Map<String, dynamic>>> getGroups(String userID) async {
    //final List<Group> groups = [];
/*
    await groupCollection
        .where("users",
            arrayContains: FirebaseFirestore.instance.doc("users/" + userID))
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) => {
                    groups.add(Group(doc.id, doc["name"], doc["users"],
                        doc["expenses"], doc["date"].toDate()))
                  }),
              print(groups)
            });
*/
    final List<Map<String, dynamic>> groups = [];
    await groupCollection
        .where("users",
            arrayContains: FirebaseFirestore.instance.doc("users/" + userID))
        .get()
        .then((QuerySnapshot q) => {
              q.docs.forEach((doc) => {groups.add(doc.data())})
            });
    //print(ans.docs[0].data());
    return groups;
  }

  Future<Map<String, dynamic>> addGroup(String userID, String groupName) {
    final referenceArray = [];
    referenceArray.add(FirebaseFirestore.instance.doc("users/" + userID));

    return groupCollection.add({
      "name": groupName,
      // MUST CONVERT TO DATETIME, TIMESTAMP IS NOT SAME AS DATETIME
      // https://stackoverflow.com/questions/55547133/how-to-convert-flutter-date-to-timestamp/55547142
      "date": Timestamp.fromDate(DateTime.now()),
      "expenses": [],
      "users": referenceArray,
    }).then((docReference) => docReference.get().then((doc) => doc.data()));
  }

  Future<void> deleteGroup(String userID) async {
    await groupCollection.doc(userID).delete();
  }

  updateGroupData(String name, Timestamp date) async {
    //Map<String, dynamic>
    //groupCollection.add(data)
    return await groupCollection.doc().set({
      'name': name,
      'date': date,
    });
  }

  // group list from snapshot
  // List<DbGroup> _groupListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return DbGroup(
  //         name: doc.data()['name'] ?? "", date: doc.data()['date'] ?? "");
  //   }).toList();
  // }

  // // get groups stream
  // Stream<List<DbGroup>> get groups {
  //   return groupCollection.snapshots().map(_groupListFromSnapshot);
  // }
}
