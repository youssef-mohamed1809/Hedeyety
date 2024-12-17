import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/LocalDB.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'UserModel.dart';

class Authentication{

  static login(email, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      UserModel? user = await CurrentUser.getCurrentUser();
      Event.synchronizeFirebaseWithLocal();
      RealTimeDatabase.listenForUpdates();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return 'An error occurred, please try again.';
    }
  }

  static signup(name, username, email, password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      await UserModel.add_new_user_to_db(
          uid: user?.uid,
          name: name,
          username: username,
          email: email
      );
      UserModel? x = await CurrentUser.getCurrentUser();
      RealTimeDatabase.listenForUpdates();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return false;
    } catch (e) {
      print(e);
      return 'An error occurred, please try again';
    }
  }

  static logout() async {
    CurrentUser.user = null;
    await FirebaseAuth.instance.signOut();
    String dbsPath = await getDatabasesPath();
    String dbPath = join(dbsPath, 'hedeyety.db');
    await deleteDatabase(dbPath);
    LocalDB.db = null;

  }

  static user_signed_in(){
    var user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return true;
    }
    return false;
  }

}