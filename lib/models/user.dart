import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class User {
  User(this.name);

  @required
  String id = uuid.v4();
  @required
  String name;
}
