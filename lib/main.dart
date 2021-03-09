import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:slash_wise/models/user_auth.dart';
import 'package:slash_wise/screens/group_screen.dart';
import 'package:slash_wise/screens/wrapper.dart';
import 'package:slash_wise/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

import "package:slash_wise/services/dbServiceGroup.dart";

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final dbInterface = DatabaseServiceGroup();
  dbInterface.addGroup("RFHPJcUFxcf0q5BqxHGiG2UooT63", "Test2");

  dbInterface.getGroups("RFHPJcUFxcf0q5BqxHGiG2UooT63");

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
