import 'package:firebase_database/firebase_database.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/LocalDB.dart';
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
    var ref = db.ref('/users/${user.uid}/events');
    var snapshot = await ref.get();
    // print(snapshot.value);
    ref.onValue.listen((event) async {
      final data = event.snapshot.value;
      // print("ANANANANANANA HMFJJSDH,DBJHDVFLB");
      // print("HI");
      if(data != null){

        var db = await LocalDB.getInstance();
        List<Map> res = await db.rawQuery("select * from events where published = 0");
        var events = [];
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

        var gifts = [];

        for(int i = 0; i < events.length; i++){
          var event_gifts =  await Gift.getLocalGifts(events[i].id);

          event_gifts.forEach((event_gift){
            gifts.add(event_gift);
          });

        }

        await Event.synchronizeFirebaseWithLocal();

        for(int i = 0; i < events.length; i++){
          await Event.createEvent(events[i].id, events[i].name, events[i].date, events[i].location, events[i].description);
        }

        for(int i = 0; i < gifts.length; i++){
          await Gift.createGift(gifts[i].id, gifts[i].name, gifts[i].description, gifts[i].category, gifts[i].price, gifts[i].event_id);
        }

      }
    });
  }


}