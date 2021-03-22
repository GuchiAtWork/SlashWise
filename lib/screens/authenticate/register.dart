import "package:flutter/material.dart";
import 'package:slash_wise/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String username = '';
  String password = '';
  String error = "";
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget _appBar =
        AppBar(title: Text("Welcome to SlashWise"));
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height -
              _appBar.preferredSize.height -
              MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/signin.jpeg'), fit: BoxFit.cover),
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
                        filled: true),
                    validator: (val) =>
                        val.isEmpty ? 'Enter an Email Address' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                      decoration: InputDecoration(
                          hintText: "Username",
                          fillColor: Colors.white,
                          filled: true),
                      validator: (val) =>
                          val.isEmpty ? 'Enter an username' : null,
                      onChanged: (val) {
                        setState(() => username = val);
                      }),
                  SizedBox(height: 40.0),
                  TextFormField(
                      decoration: InputDecoration(
                          hintText: "Password",
                          fillColor: Colors.white,
                          filled: true),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter an password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      }),
                  SizedBox(height: 40.0),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      child: Text(
                        "Sign Up",
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, username, password);
                          if (result == null) {
                            setState(
                                () => error = "please supply a valid email");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigo[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          elevation: 5.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      child: Text("Log In"),
                      onPressed: () {
                        widget.toggleView();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigo[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          elevation: 5.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
