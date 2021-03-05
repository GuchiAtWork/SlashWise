import 'package:flutter/foundation.dart';

class User {
  User(this.name);

  @required
  String id = DateTime.now().toString();
  @required
  String name;
}
