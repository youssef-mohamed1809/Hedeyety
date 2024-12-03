import 'package:firebase_auth/firebase_auth.dart';
import'package:firebase_database/firebase_database.dart';
import 'RTdb.dart';
import 'UserModel.dart';

class Authentication{

  static login(email, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  static signup(name, username, email, password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      await UserModel.add_to_db(
          uid: user?.uid,
          name: name,
          username: username,
          email: email
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static user_signed_in(){
    var user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return true;
    }
    return false;
  }



}