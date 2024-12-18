
import 'package:hedeyety/Model/Authentication.dart';
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

  Event({this.id, this.name, this.date, this.location, this.description, this.published});
  Map<String, Object?> toMap(){
    return {
      'id': id,
      'name': name,
      'date': "${date!.year}-${date!.month}-${date!.day}",
      'location': location,
      'description': description,
      'published': published
    };
  }

  static synchronizeFirebaseWithLocal() async {
    var id = UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child('users/$id/events/');
    var snapshot = await ref.get();
    if(snapshot.value == null){
      return;
    }
    var data = snapshot.value as Map;
    for (var entry in data.entries) {
      var eventDetails = entry.value;
        await createEvent(
          eventDetails['id'],
          eventDetails['name'],
          DateTime.parse(eventDetails['date']),
          eventDetails['location'],
          eventDetails['description'],
        );
        if(eventDetails['gifts'] != null){
          for(var gift_entry in eventDetails['gifts'].entries){
            var giftDetails = gift_entry.value;
            // print(giftDetails);
            await Gift.createGift(
                giftDetails['id'],
                giftDetails['name'],
                giftDetails['description'],
                giftDetails['category'],
                giftDetails['price'],
                eventDetails['id'],
                status: giftDetails['status']
            );
          }
        }
    }

  }
  static createEvent(id, name, DateTime date, location, description) async{
    var db = await LocalDB.getInstance();
    if(id == -1){
      await db.insert(
          'events',
          {
            'name': name,
            'date': "${date.year}-${date.month}-${date.day}",
            'location': location,
            'description': description,
            'published': 0
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }else{
      await db.insert(
          'events',
          {
            'id': id,
            'name': name,
            'date': "${date.year}-${date.month}-${date.day}",
            'location': location,
            'description': description,
            'published': 1
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
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
            description: row['description'],
            published: row['published'],
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
      // print("Events: $events with id: $id");
      if(events == null){
        return 0;
      }else{
      int count = 0;
      for(final key in events.keys){
        DateTime d = DateTime.parse(events[key]['date']);
        if(d.compareTo(DateTime.now()) >= 0){
          count++;
        }
      }

      return count;
      }
    }catch(e){
      print("Error in getNumberOfUpcomingEvents");
      print(e);
    }


  }
  static Future<List<Event>> getFriendsEvents(id) async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$id/events");
    try{
      var snapshot = await ref.get();
      var data = snapshot.value;
      List<Event> events = [];
      if(data == null){
        print("No data");
        return [];
      }
      for(var event_num in data.keys){
        events.add(Event(
            id: data[event_num]['id'],
            name: data[event_num]['name'],
            date: DateTime.parse(data[event_num]['date']),
            location: data[event_num]['location'],
            description: data[event_num]['description'],
            published: 1
        ));
      }
      return events;
    }catch(e){
      print("Error in getFriendEvents");
      print(e);
      return [];
    }
  }

  publishEvent() async{
    var userID = await UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var gifts_obj  = await Gift.getLocalGifts(id);
    var events_gifts_maps = [];
    try{
      gifts_obj.forEach((gift){
        events_gifts_maps.add(gift.toMap());
      });
    }catch(e){
      print("From Publish event");
      print(e);
    }

    var ref = db.ref().child('users/$userID/events/eventN${id}');
    published = 1;
    await ref.set(this.toMap());
    for(var gift in events_gifts_maps) {
      var ref = db.ref().child(
          'users/$userID/events/eventN${id}/gifts/giftN${gift['id']}');

      await ref.set(gift);
      ref = db.ref("/users/${userID}/events/eventN${id}/gifts/${gift['id']}");
      ref.onChildChanged.listen((event) async {
        if(event.snapshot.key == "status"){
          print("Status Changed");
          var db = LocalDB.getInstance();
          await db.update(
              'gifts',
              {
                "status": event.snapshot.value
              },
              where: 'id = ?',
              whereArgs: [gift['id']]
          );
        }
      });
    }


    published = 1;
    await updateEvent();

  }
  Future updateEvent() async{
    var db = await LocalDB.getInstance();
    db.update(
        'events',
        this.toMap(),
        where: 'id = ?',
        whereArgs: [id]
    );


    if(published == 1){
      var userID = await UserModel.getCurrentUserUID();
      db = RealTimeDatabase.getInstance();
      var ref = db.ref().child("/users/$userID/events/eventN${id}");
      ref.update({
        "date": "${date!.year}-${date!.month}-${date!.day}",
        "description": description,
        "location": location,
        "name": name,
      });

    }
  }

  Future deleteEvent() async{
    var db = await LocalDB.getInstance();
    await db.delete(
        'events',
        where: 'id = ?',
        whereArgs: [id]
    );

    await db.delete(
        'gifts',
        where: 'event_id = ?',
        whereArgs: [id]
    );

    if(published == 1){
      var userID = await UserModel.getCurrentUserUID();
      db = RealTimeDatabase.getInstance();
      var ref = db.ref().child("/users/$userID/events/eventN${id}");

      ref.remove();
    }

  }

}