import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/screens/home/home.dart';
import 'package:slash_wise/screens/wrapper.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:slash_wise/services/dbServiceExpense.dart';
import "package:slash_wise/services/dbServiceGroup.dart";
import 'dart:convert';
import 'package:slash_wise/services/dbServiceUser.dart';
import 'package:slash_wise/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:slash_wise/screens/PayPalPayment.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
/*
  final test =
      await dbInterface.addGroup("RFHPJcUFxcf0q5BqxHGiG2UooT63", "Test2");
  print(test["name"]);
  dbInterface.deleteGroup("Agvo8XSlcjEAOqd3QoFO");
  */

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: myTheme,
        initialRoute: PaypalPayment.routeName,
        routes: {
          '/': (context) => Wrapper(),
          PaypalPayment.routeName: (context) => PaypalPayment(),
          GroupScreen.routeName: (context) => GroupScreen(),
        },
      ),
    );
  }
}
