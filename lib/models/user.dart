import 'package:flutter/foundation.dart';

class User {
  User(this.id, this.name, this.email);

  @required
  String id;
  @required
  String name;
  @required
  String email;
}
