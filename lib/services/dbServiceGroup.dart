import 'dart:io';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:slash_wise/models/dbGroup.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';
import "package:slash_wise/services/dbServiceUser.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// RFHPJcUFxcf0q5BqxHGiG2UooT63

class DatabaseServiceGroup {
  //collection reference
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Stream<List<DbGroup>> groups() {
    return groupCollection
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (e) => DbGroup(e.id, e.data()['name'],
                  e.data()['users']?.cast<String>(), e.data()['date'].toDate()),
            )
            .toList());
  }

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

  Future<void> removeMemberFromGroup(String groupID, String currUserID) async {
    final group = await getGroup(groupID);
    List<String> memberList = group.users;
    List<String> updatedMemberList =
        memberList.where((member) => member != currUserID).toList();

    if (updatedMemberList.length == 0) {
      await groupCollection.doc(groupID).delete();
      await expenseCollection
          .where("groupID", isEqualTo: groupID)
          .get()
          .then((QuerySnapshot q) => q.docs.forEach((doc) {
                FirebaseStorage.instance.ref(doc.reference.id).delete();
                doc.reference.delete();
              }));
    } else {
      await groupCollection
          .doc(groupID)
          .update({"users": updatedMemberList}).then(
              (res) => print("User successfully removed from group"));
    }
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

  Future<void> updateGroup(String groupID, String groupName) async {
    await groupCollection.doc(groupID).update({'name': groupName});
  }

  Future<String> uploadGroupIcon(String groupID, File fileImage) async {
    return FirebaseStorage.instance
        .ref('$groupID')
        .getMetadata()
        .then((image) async {
      await FirebaseStorage.instance.ref(groupID).delete();
      await FirebaseStorage.instance.ref(groupID).putFile(fileImage);
      String downloadURL =
          await FirebaseStorage.instance.ref(groupID).getDownloadURL();
      return downloadURL;
    }).catchError((onError) async {
      await FirebaseStorage.instance.ref(groupID).putFile(fileImage);
      String downloadURL =
          await FirebaseStorage.instance.ref(groupID).getDownloadURL();
      return downloadURL;
    });
  }

  Future<String> getGroupIcon(String groupID) async {
    String downloadURL = await FirebaseStorage.instance
        .ref(groupID)
        .getDownloadURL()
        .then((image) {
      return image;
    }).catchError((onError) {
      return "https://he.cecollaboratory.com/public/layouts/images/group-default-logo.png";
    });
    return downloadURL;
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
