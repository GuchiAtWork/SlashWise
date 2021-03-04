import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user.dart';
import 'package:slash_wise/screens/authenticate/authenticate.dart';
import 'package:slash_wise/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either Home or Authenticate wideget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
