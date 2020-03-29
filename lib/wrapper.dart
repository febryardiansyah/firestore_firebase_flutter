import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebase_flutter/login_page.dart';
import 'package:firestore_firebase_flutter/main.dart';
import 'package:firestore_firebase_flutter/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    return (firebaseUser == null)?LoginPage(): MainPage(firebaseUser);
  }
}

