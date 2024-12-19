import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/SynchronizationAndListeners.dart';
import 'package:hedeyety/Model/UserModel.dart';
import 'package:uuid/uuid.dart';

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
  String? imgURL;

  Gift({this.id, this.name, this.description, this.category, this.price, this.status, this.imgURL});

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'status': status,
      'imgURL': imgURL
    };
  }

  static createGift(id, name, description, category, price, event_id, {String? status, String? imgURL}) async {
    var db = await LocalDB.getInstance();
    if(id == -1){
      int gid = await db.insert(
          'gifts',
          {
            'name': name,
            'description': description,
            'price': price,
            'category': category,
            'status': 0,
            'event_id': event_id,
            'imgURL': imgURL
          },
          conflictAlgorithm: ConflictAlgorithm.replace
      );

      var res = await db.rawQuery("select published from events where id = ${event_id}");

      if(res[0]["published"] == 1){
        var userID = await UserModel.getCurrentUserUID();
        db = await RealTimeDatabase.getInstance();
        var ref = db.ref().child("/users/$userID/events/eventN${event_id}/gifts/giftN${gid}");
        await ref.set({
          'id': gid.toString(),
          'name': name,
          'category': category,
          'price': price,
          'description': description,
          'status': "0",
          'imgURL': imgURL
        });
        SynchronizationAndListeners.listenForStatusChanges(ref, gid.toString());
      }

    }else{
      await db.insert(
          'gifts',
          {
            'id': id,
            'name': name,
            'description': description,
            'price': price,
            'category': category,
            'status': status??"0",
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
    List event_ids = [];

    res.forEach((row){

      try{
        gifts.add(Gift(
          id: row['id'].toString(),
          name: row['name'],
          description: row['description'],
            category: row['category'].toString(),
            price: row['price'].toString(),
            status: row['status'].toString(),
            imgURL: row['imgURL']
        ));
        event_ids.add(row['event_id']);
      }catch(e){
        print("From getLocalGifts");
        print(e);
      }
    });

    return [gifts, event_ids];
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

      var uuid = Uuid();
      var pledgedGiftId = uuid.v4();

      UserModel user  = await CurrentUser.getCurrentUser();
      ref = db.ref().child("users/${user.uid}/pledgedGifts/$pledgedGiftId");
      // print(giftOwnerID);
      await ref.set({
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'description': description,
        'status': status,
        'eventId': eventId,
        'giftRequesterId': giftOwnerID,
        'pledgedGiftId': pledgedGiftId
      });

      return true;
    }catch(e){
      print("From pledgeGift");
      print(e);

      return false;
    }
  }


  Future editGift() async {
      var db = await LocalDB.getInstance();
      db.update(
          'gifts',
          this.toMap(),
          where: 'id = ?',
          whereArgs: [id]
      );

      var res = await db.rawQuery("select event_id from gifts where id = ${id}");
      print(res);
      var event_id = res[0]["event_id"];
      res = await db.rawQuery("select published from events where id = ${event_id}");

      if(res[0]["published"] == 1){
            var userID = await UserModel.getCurrentUserUID();
            db = RealTimeDatabase.getInstance();
            var ref = db.ref().child("/users/$userID/events/eventN${event_id}/gifts/giftN${id}");
            ref.update({
              "category": category,
              "description": description,
              "name": name,
              "price": price,
            });
      }
  }

  Future deleteGift() async {
    var db = await LocalDB.getInstance();
    db.delete(
        'gifts',
        where: 'id = ?',
        whereArgs: [id]
    );

    var res = await db.rawQuery("select event_id from gifts where id = ${id}");
    print(res);
    var event_id = res[0]["event_id"];
    res = await db.rawQuery("select published from events where id = ${event_id}");

    if(res[0]["published"] == 1){
      var userID = await UserModel.getCurrentUserUID();
      db = RealTimeDatabase.getInstance();
      var ref = db.ref().child("/users/$userID/events/eventN${event_id}/giftN${id}");
      ref.remove();
    }

  }

  static getGiftCategories() async {
    var db = await LocalDB.getInstance();
    var res = await db.rawQuery("select * from category");
    // var cats = [];
    // res.forEach((cat){
    //   cats.add(cat['category']);
    // });
    print(res);
    return res;
  }

}