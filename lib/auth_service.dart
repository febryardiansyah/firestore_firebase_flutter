import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //deklarasi
  static FirebaseAuth _auth = FirebaseAuth.instance;

  //sign anonym
  static Future<FirebaseUser> signAnonym()async{
    //handle error
    try{
      AuthResult _result = await _auth.signInAnonymously();
      FirebaseUser user = _result.user;

      return user;
    }catch(e){
      print(e.toString());

      return null;
    }
  }

  //sign up emailPassword
  static Future<FirebaseUser>signUp(String email,String password)async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;

      return firebaseUser;
    }catch(e){
      print(e.toString());
    }
  }

  //sign emailpassword
  static Future<FirebaseUser>signInEmailPass(String email, String password)async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    }catch(e){
      print(e.toString());
    }
  }

  //signout user
  static Future<void> signOut()async{
    _auth.signOut();
  }

  //memberitahu perubahan
  static Stream<FirebaseUser> get firebaseUserStream => _auth.onAuthStateChanged;
}