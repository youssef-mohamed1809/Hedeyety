import 'package:firebase_database/firebase_database.dart';


class RealTimeDatabase{

  static FirebaseDatabase? db;

  static getInstance(){
      if(db == null){
        db = FirebaseDatabase.instance;
      }
      return db;
  }


}