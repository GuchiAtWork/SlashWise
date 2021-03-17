import "package:flutter/material.dart";
import 'package:slash_wise/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome back!"), actions: <Widget>[
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          icon: Icon(Icons.person),
          label: Text("Register"),
          onPressed: () {
            widget.toggleView();
          },
        )
      ]),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/signin.jpeg'), fit :BoxFit.cover),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    fillColor: Colors.white,
                    filled: true
                    ),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 40.0),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      filled: true,
                      ),
                    validator: (val) => val.length < 6
                        ? 'Enter an password 6+ chars long'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    }),
                SizedBox(height: 40.0),
                ElevatedButton(
                    child: Text("Log In"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email, password);
                        if (result == null) {
                          setState(() => error =
                              "could not sign in with those credentials");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      elevation: 5.0,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    ),
                SizedBox(height: 40.0),
                ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () {
                      widget.toggleView();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[900],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      elevation: 5.0,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    ),
              ],
            )),
      ),
    );
  }
}
