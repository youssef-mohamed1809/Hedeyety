import 'package:sqflite/sqflite.dart';

import 'LocalDB.dart';

class Event{
  int? id;
  String? name;
  DateTime? date;
  String? location;
  String? description;

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description
    };
  }

  static createEvent(name, date, location, description) async{

    var db = await LocalDB.getInstance();

    await db.insert(
      'events',
      {
        'name': name,
        'date': date,
        'location': location,
        'description': description
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );

  }

  static getAllEvents() async {
    var db = await LocalDB.getInstance();
    List<Map> res = await db.rawQuery("select * from events");
    res.forEach((row) => print(row));
  }

}