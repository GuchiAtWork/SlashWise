import 'package:cloud_firestore/cloud_firestore.dart';

class DbGroup {
  final String name;
  final Timestamp date;
  DbGroup({this.name, this.date});
}