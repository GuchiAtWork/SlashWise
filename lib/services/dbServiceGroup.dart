import 'dart:io';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slash_wise/models/dbGroup.dart';
import "package:slash_wise/services/dbServiceUser.dart";

// RFHPJcUFxcf0q5BqxHGiG2UooT63

class DatabaseServiceGroup {
  //collection reference
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future<String> uploadGroupImage(
      String groupID, PickedFile pickedImage) async {
    File img = File(pickedImage.path);
    await FirebaseStorage.instance.ref('GroupImage/$groupID').putFile(img);
    String downloadURL = await FirebaseStorage.instance
        .ref('GroupImage/$groupID')
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> getGroupImage(String groupID) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('GroupImage/$groupID')
        .getDownloadURL();

    return downloadURL;
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

  Future<void> updateGroup(String groupID, String groupName) async {
    await groupCollection.doc(groupID).update({'name': groupName});
  }
}
