import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'LocalDB.dart';

class Event{
  int? id;
  String? name;
  DateTime? date;
  String? location;
  String? description;
  int? published;

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description
    };
  }

  Event({this.id, this.name, this.date, this.location, this.description, this.published});

  static createEvent(name, date, location, description) async{
    var db = await LocalDB.getInstance();
    await db.insert(
      'events',
      {
        'name': name,
        'date': date,
        'location': location,
        'description': description,
        'published': 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }



  // static publishEvent(Event event) async{
  //   // var userID = await UserModel.getCurrentUserUID();
  //   // var db = RealTimeDatabase.getInstance();
  //   // var ref = db.ref().child('users/$userID/events/${event.id}');
  //   // await ref.set({
  //   //   'name': event.name,
  //   //   'date': "${event.date?.year}-${event.date?.month}-${event.date?.day}",
  //   //   'location': event.location,
  //   //   'description': event.description
  //   // });
  // }



  static getAllEvents() async {
    var db = await LocalDB.getInstance();
    List<Map> res = await db.rawQuery("select * from events");
    List events = [];

    res.forEach((row){

      List<String> parts = row['date'].split('-');
      String year = parts[0];
      String month = parts[1].padLeft(2, '0');
      String day = parts[2].padLeft(2, '0');
      var date = '$year-$month-$day';

      try{
        events.add(Event(
            name: row['name'],
            date: DateTime.parse(date),
            location: row['location'],
            description: row['description']
        ));
      }catch(e){
        print(e);
        print("skipping");
      }
    });
  // print(res);


    return events;
  }

  static getUpcomingEventNames() async {
    var db = await LocalDB.getInstance();
    List<Map> res = await db.rawQuery("select * from events");

    List events = [];
    res.forEach((event){
      List<String> parts = event['date'].split('-');
      String year = parts[0];
      String month = parts[1].padLeft(2, '0');
      String day = parts[2].padLeft(2, '0');
      var date = '$year-$month-$day';
      DateTime d = DateTime.parse(date);

      if(d.compareTo(DateTime.now()) > 0){
          events.add(event);
      }
    });

  // print(events);
    return events;
  }




  static getNumberOfUpcomingEvents(id) async {

    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$id/events");
    try{
      var snapshot = await ref.get();
      var events = snapshot.value;
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
      return count;
    }catch(e){
      print(e);
    }


  }

}