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

  static synchronizeFirebaseWithLocal() async {
    var id = UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child('users/$id/events/');
    var snapshot = await ref.get();
    var data = snapshot.value as Map;
    for (var entry in data.entries) {
      var eventDetails = entry.value;
        await createEvent(
          eventDetails['id'],
          eventDetails['name'],
          eventDetails['date'],
          eventDetails['location'],
          eventDetails['description'],
        );
        if(eventDetails['gifts'] != null){
          for(var gift_entry in eventDetails['gifts'].entries){
            var giftDetails = gift_entry.value;
            print(giftDetails);
            await Gift.createGift(
                giftDetails['id'],
                giftDetails['name'],
                giftDetails['description'],
                giftDetails['category'],
                giftDetails['price'],
                eventDetails['id'],
                status: int.parse(giftDetails['status'])
            );
          }
        }
    }

  }


  static createEvent(id, name, date, location, description) async{
    var db = await LocalDB.getInstance();
    if(id == -1){
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
    }else{
      await db.insert(
          'events',
          {
            'id': id,
            'name': name,
            'date': date,
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

    var ref = db.ref().child('users/$userID/events/eventN${event.id}');
    await ref.set({
      'id': event.id,
      'name': event.name,
      'date': "${event.date?.year}-${event.date?.month}-${event.date?.day}",
      'location': event.location,
      'description': event.description,
    });

    // print(events_gifts_maps);
    for(var gift in events_gifts_maps) {
      var ref = db.ref().child(
          'users/$userID/events/eventN${event.id}/gifts/giftN${gift['id']}');
      await ref.set(gift);
    }



    await event.updatePublished(1);

  }

  Future<void> updatePublished(value) async{
    var db = await LocalDB.getInstance();
    await db.rawUpdate("update events set published = $value where id = $id");
  }








}