import 'package:hedeyety/Model/RTdb.dart';
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



  static getNumberOfUpcomingEvents(id) async {

    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$id/events");
    print('bye');
    try{
      var snapshot = await ref.get();
      var events = snapshot.value;
      // print(events);
      if(events == null){
        return 0;
      }
      int count = 0;
      events.forEach((e){

        DateTime d = DateTime.parse(e['date']);
        if(d.compareTo(DateTime.now()) >= 0){
          count++;
          print("hi");
        }
      });
      // print(count);
      return count;
    }catch(e){
      print(e);
    }


  }

}