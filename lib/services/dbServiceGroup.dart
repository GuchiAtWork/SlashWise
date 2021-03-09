import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbGroup.dart';
import "package:slash_wise/services/dbServiceUser.dart";
//import 'package:slash_wise/models/group.dart';

// RFHPJcUFxcf0q5BqxHGiG2UooT63

class DatabaseServiceGroup {
  //collection reference
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  /*
  Future<List<DbGroup>> getGroups2(String userID) async {
    final List<DbGroup> groups = [];

    await groupCollection
        .where("users",
            arrayContains: FirebaseFirestore.instance.doc("users/" + userID))
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) => {
                    groups.add(DbGroup(doc.data()["id"], doc.data()["name"],
                        doc.data()["users"], doc.data()["date"].toDate()))
                  }),
            });
    return groups;
  }*/

  Future<DbGroup> getGroup(String groupID) async {
    return await groupCollection
        .doc(groupID)
        .get()
        .then((DocumentSnapshot doc) {
      final DbGroup caughtGroup = DbGroup(doc.id, doc["name"],
          doc["users"]?.cast<String>(), doc["date"].toDate());
      return caughtGroup;
    });
  }

  Future<List<DbGroup>> getGroups(String userID) async {
    final List<DbGroup> groups = [];
    await groupCollection
        .where("users", arrayContains: userID)
        .get()
        .then((QuerySnapshot q) => {
              q.docs.forEach((doc) {
                final DbGroup capturedGroup = DbGroup(doc.id, doc["name"],
                    doc["users"]?.cast<String>(), doc["date"].toDate());
                groups.add(capturedGroup);
              })
            });
    return groups;
  }

  Future<DbGroup> addGroup(
      String userID, String groupName, DateTime date) async {
    final List<String> referenceArray = [];
    referenceArray.add(userID);

    final newGroup = await groupCollection.add({
      "name": groupName,
      // MUST CONVERT TO DATETIME, TIMESTAMP IS NOT SAME AS DATETIME
      // https://stackoverflow.com/questions/55547133/how-to-convert-flutter-date-to-timestamp/55547142
      "date": Timestamp.fromDate(date),
      //"expenses": [],
      "users": referenceArray,
    }).then((docReference) {
      final newGroup =
          DbGroup(docReference.id, groupName, referenceArray, date);
      return newGroup;
    });

    return newGroup;
  }

  Future<void> deleteGroup(String groupID) async {
    await groupCollection.doc(groupID).delete();
  }

  Future<void> addMemberToGroup(String groupID, String email) async {
    final userDbInterface = DatabaseServiceUser();

    final otherUser = await userDbInterface.getUserByEmail(email);

    if (otherUser == null) {
      print("User doesn't exist");
      return;
    }

    final DbGroup group = await getGroup(groupID);
    final List<String> groupMembers = group.users;
    groupMembers.add(otherUser.id);

    return groupCollection.doc(groupID).update({"users": groupMembers}).then(
        (result) => print("User successfully added"));
  }

/*
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
*/
}
