import 'package:hedeyety/Model/RTdb.dart';

import 'LocalDB.dart';
import 'package:sqflite/sqflite.dart';

class Gift{

  String? id;
  String? description;
  String? category;
  String? price;
  String? pledged;
  String? name;
  String? status;

  Gift({this.id, this.name, this.description, this.category, this.price, this.status});

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'status': status
    };
  }

  static createGift(id, name, description, category, price, event_id, {int? status}) async {
    var db = await LocalDB.getInstance();
    if(id == -1){
      await db.insert(
          'gifts',
          {
            'name': name,
            'description': description,
            'price': price,
            'category': category,
            'status': 0,
            'event_id': event_id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }else{
      await db.insert(
          'gifts',
          {
            'id': id,
            'name': name,
            'description': description,
            'price': price,
            'category': category,
            'status': status,
            'event_id': event_id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
  }
  static getLocalGifts(event_id) async {
    var db = await LocalDB.getInstance();
    String query = "";

    if(event_id == -1){
      query = "select * from gifts";
    }else{
      query = "select * from gifts where event_id = $event_id";
    }

    List<Map> res = await db.rawQuery(query);
    List gifts = [];

    res.forEach((row){

      try{
        gifts.add(Gift(
          id: row['id'].toString(),
          name: row['name'],
          description: row['description'],
            category: row['category'].toString(),
            price: row['price'].toString(),
            status: row['status'].toString()
        ));
      }catch(e){
        print("From getLocalGifts");
        print(e);
      }
    });
    // print(res);
    // print(gifts);

    return gifts;
  }
  static getFriendGifts(friendId, eventId) async{
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$friendId/events/eventN$eventId/gifts");
    try{
      var snapshot = await ref.get();
      Map data = snapshot.value;
      // print(data);
      List<Gift> gifts = [];
      for(var giftKey in data.keys){
        gifts.add(Gift(
          id: data[giftKey]['id'],
          name: data[giftKey]['name'],
          description: data[giftKey]['description'],
          category: data[giftKey]['category'],
          price: data[giftKey]['price'],
          status: data[giftKey]['status'],
        ));
      }
      return gifts;
      // print(data);
    }catch(e){
      print("From getFriendsGifts");
      print(e);
      return null;
    }
  }

  pledgeGift(giftOwnerID, eventId) async {
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child("users/$giftOwnerID/events/eventN$eventId/gifts/giftN$id/");

    try{
      await ref.update({"status": "1"});
      status = "1";
    }catch(e){
      print("From pledgeGift");
      print(e);
    }
  }

}