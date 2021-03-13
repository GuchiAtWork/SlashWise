import 'package:flutter/material.dart';
import 'package:slash_wise/models/user.dart';

class MultipleNotifier extends ChangeNotifier {
  List<User> _selectedUsers;
  MultipleNotifier(this._selectedUsers);
  List<User> selectedUsers() => _selectedUsers;

  bool isHaveUser(User user) => _selectedUsers.contains(user);

  addUser(User user) {
    if (!isHaveUser(user)) {
      _selectedUsers.add(user);
      notifyListeners();
    }
  }

  removeUser(User user) {
    if (isHaveUser(user)) {
      _selectedUsers.remove(user);
      notifyListeners();
    }
  }
}
