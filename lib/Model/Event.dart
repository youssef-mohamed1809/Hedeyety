import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:sqflite/sqflite.dart';

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
  static getAllMyEvents() async {
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
          id: row['id'],
            name: row['name'],
            date: DateTime.parse(date),
            location: row['location'],
            description: row['description']
        ));
      }catch(e){
        print("Error in getAllMyEvents");
        print(e);
      }
    });


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
        }
      });
      return count;
    }catch(e){
      print("Error in getNumberOfUpcomingEvents");
      print(e);
    }


  }


  static publishEvent(Event event) async{
    var userID = await UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var gifts_obj  = await Gift.getLocalGifts(event.id);
    var events_gifts_maps = [];
    try{
      gifts_obj.forEach((gift){
        events_gifts_maps.add(gift.toMap());
      });
    }catch(e){
      print("From Publish event");
      print(e);
    }

    var ref = db.ref().child('users/$userID/events/${event.id}');
    await ref.set({
      'name': event.name,
      'date': "${event.date?.year}-${event.date?.month}-${event.date?.day}",
      'location': event.location,
      'description': event.description,
      'gifts': events_gifts_maps
    });

    await event.updatePublished(1);

  }

  Future<void> updatePublished(value) async{
    var db = await LocalDB.getInstance();
    await db.rawUpdate("update events set published = $value where id = $id");
  }








}