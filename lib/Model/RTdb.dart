import 'package:firebase_database/firebase_database.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/UserModel.dart';


class RealTimeDatabase{

  static FirebaseDatabase? db;

  static getInstance(){
      db ??= FirebaseDatabase.instance;
      return db;
  }

  static listenForUpdates() async {
    var db = getInstance();
    UserModel user = await CurrentUser.getCurrentUser();
    var ref = db.ref('/users/${user.uid}/');
    var snapshot = await ref.get();
    print(snapshot.value);
    ref.onValue.listen((event) async {
      final data = event.snapshot.value;
      print("HI");
      if(data != null){
        await Event.synchronizeFirebaseWithLocal();
      }
    });
  }


}