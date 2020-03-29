import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_firebase_flutter/add_animex.dart';
import 'package:firestore_firebase_flutter/auth_service.dart';
import 'package:firestore_firebase_flutter/database_services.dart';
import 'package:firestore_firebase_flutter/edit_data.dart';
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
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAnimex(),fullscreenDialog: true));
        },
      ),
      body: SingleChildScrollView(
        child: Center(
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
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (direction)async{
                              final bool res = await showDialog(context: context,builder: (context){
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Kau Yakin ?'),
                                  actions: <Widget>[
                                    FlatButton(child: Text('Hapus'),onPressed: (){Navigator.of(context).pop(true);},),
                                    FlatButton(child: Text('Batal'),onPressed: (){Navigator.of(context).pop(false);},)
                                  ],
                                );
                              });
                              return res;
                            },
                            onDismissed: (value){
                              DatabaseServices.deleteData(documant);
                            },
                            child: ListTile(
                              leading: Text(documant['score']),
                              title: Text(documant['name']),
                              subtitle: Text(documant['genre']),
                              trailing: Text('Edit'),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditData(
                                    name: documant['name'],genre: documant['genre'],score: documant['score'],currentDoc: documant,),
                                    fullscreenDialog: true));
                              },
                            ),
                          );
                        }).toList()
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
