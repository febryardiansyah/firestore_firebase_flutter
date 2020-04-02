import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_firebase_flutter/add_animex.dart';
import 'package:firestore_firebase_flutter/auth_service.dart';
import 'package:firestore_firebase_flutter/database_services.dart';
import 'package:firestore_firebase_flutter/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage(this.user);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final database = Firestore.instance;
  File imageRes;
  String _uploadFileUrl;

  Future getImage()async{
    await ImagePicker.pickImage(source: ImageSource.gallery).then((res){
      setState(() {
        imageRes = res;
      });
    });
  }
  Future uploadPic()async{
    String fileName = basename(imageRes.path);
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(imageRes);
    await uploadTask.onComplete;
    print('File uploaded');
    await storageReference.getDownloadURL().then((res){
      setState(() {
        _uploadFileUrl = res;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
                SizedBox(height: 10,),
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.green,
                      child: ClipOval(
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: imageRes!=null?Image.file(imageRes,fit: BoxFit.cover,):Image.network(
                            'https://images.unsplash.com/photo-1576158114131-f211996e9137?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1100&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: (){
                        getImage();
                      },
                    )
                  ],
                ),
                _uploadFileUrl == null?Container(
                  height: 100,
                  width: 100,
                ):Image.asset(_uploadFileUrl),
                Center(
                  child: RaisedButton(
                    child: Text('Simpan'),
                    onPressed: (){
                      uploadPic();
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(widget.user.uid),
                    RaisedButton(
                      child: Text('Log out'),
                      onPressed: () async {
                        await AuthService.signOut();
                      },
                    ),
                  ],
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
