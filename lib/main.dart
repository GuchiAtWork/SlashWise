import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/screens/wrapper.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:slash_wise/services/dbServiceGroup.dart";
import 'package:slash_wise/services/dbServiceUser.dart';
import './models/user.dart' as userModel;

import 'models/dbGroup.dart';

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
    return MultiProvider(
      providers: [
        StreamProvider<AuthUser>.value(
          initialData: null,
          value: AuthService().user,
        ),
        StreamProvider<List<DbGroup>>.value(
          initialData: [],
          value: DatabaseServiceGroup().groups(),
        ),
        StreamProvider<List<userModel.User>>.value(
          initialData: [],
          value: DatabaseServiceUser().users(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.purple),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          GroupScreen.routeName: (context) => GroupScreen(),
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<AuthUser>.value(
//       initialData: null,
//       value: AuthService().user,
//       child: MaterialApp(
//         theme: ThemeData(primarySwatch: Colors.purple),
//         initialRoute: '/',
        // routes: {
        //   '/': (context) => Wrapper(),
        //   GroupScreen.routeName: (context) => GroupScreen(),
        // },
//       ),
//     );
//   }
// }
