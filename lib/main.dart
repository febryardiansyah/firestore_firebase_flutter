import 'package:firestore_firebase_flutter/auth_service.dart';
import 'package:firestore_firebase_flutter/wrapper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService.firebaseUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.green),
        home: Wrapper(),
      ),
    );
  }
}