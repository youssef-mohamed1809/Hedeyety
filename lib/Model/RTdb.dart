import 'package:firebase_database/firebase_database.dart';


class RealTimeDatabase{

  static FirebaseDatabase? db;

  static getInstance(){
      db ??= FirebaseDatabase.instance;
      return db;
  }


}