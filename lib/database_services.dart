import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static Firestore db = Firestore.instance;

  static Future<void> addData(String name, String score, String genre) async {
    await db
        .collection('banners')
        .add({'name': name, 'score': score, 'genre': genre});
  }

  static Future<bool> editData(String name, String score, String genre,
      DocumentSnapshot currentDoc) async {
    await db
        .collection('banners')
        .document(currentDoc.documentID)
        .updateData({'name': name, 'score': score, 'genre': genre}).whenComplete((){
          print('Update Berhasil');
    });
  }
  static Future<void> deleteData(DocumentSnapshot documentSnapshot)async{
    await db.collection('banners').document(documentSnapshot.documentID).delete();
  }
}
