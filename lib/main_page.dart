import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebase_flutter/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage(this.user);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final database = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Text(widget.user.uid),
              RaisedButton(
                child: Text('Log out'),
                onPressed: () async {
                  await AuthService.signOut();
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: database.collection('banners')
                    .orderBy('score')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitChasingDots(color: Colors.green));
                  }
                  return ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot documant) {
                        return ListTile(
                          leading: Text(documant['score']),
                          title: Text(documant['name']),
                        );
                      }).toList()
                  );
                },
              )
            ],
          )),
    );
  }
}
