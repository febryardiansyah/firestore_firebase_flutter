import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebase_flutter/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 300,
              height: 100,
              child: TextField(
                controller: emailCtrl,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                controller: passCtrl,
              ),
            ),
            RaisedButton(
              child: Text('Sign In Email Password'),
              onPressed: () async {
                FutureBuilder(
                  future: AuthService.signInEmailPass(emailCtrl.text, passCtrl.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    }
                    return CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    );
                  },
                );
              },
            ),
            RaisedButton(
              child: Text('Sign up'),
              onPressed: () async {
                FutureBuilder(
                  future: AuthService.signUp(emailCtrl.text, passCtrl.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    }
                    return CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    );
                  },
                );
              },
            ),
            RaisedButton(
              child: Text('Login Anonymouse'),
              onPressed: () async {
                FutureBuilder(
                  future: AuthService.signAnonym(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text('Loading...'),
                      );
                    }
                    return CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
