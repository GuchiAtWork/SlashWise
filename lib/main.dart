import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/screens/wrapper.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';

import "package:slash_wise/services/dbServiceGroup.dart";
import 'dart:convert';

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

<<<<<<< HEAD
  final dbInterface = DatabaseServiceExpense();
  final expense = await dbInterface.getExpenses("OwbmQTPeWwgpSBxgWY0z");

  print("main.dart: ");
  print(expense);
=======
  final dbInterface = DatabaseServiceGroup();
  print("#################");
  final test = await dbInterface.getGroups("RFHPJcUFxcf0q5BqxHGiG2UooT63");
  print(test[0]);
  print("@@@@@@@@@@@@@@");
/*
  final test =
      await dbInterface.addGroup("RFHPJcUFxcf0q5BqxHGiG2UooT63", "Test2");
  print(test["name"]);
  dbInterface.deleteGroup("Agvo8XSlcjEAOqd3QoFO");
  */
>>>>>>> d896deedb989b8bbb1991ec3059e37bbe0d01a46

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        //home: Wrapper(),
        initialRoute: GroupScreen.routeName,
        routes: {
          '/': (context) => Wrapper(),
          GroupScreen.routeName: (context) => GroupScreen(),
        },
      ),
    );
  }
}
