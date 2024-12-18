import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/LocalDB.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/UserModel.dart';

class SynchronizationAndListeners{

  static List<StreamSubscription> _subscriptions = [];

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
      await Event.createEvent(
        eventDetails['id'],
        eventDetails['name'],
        DateTime.parse(eventDetails['date']),
        eventDetails['location'],
        eventDetails['description'],
      );
      if(eventDetails['gifts'] != null){
        for(var gift_entry in eventDetails['gifts'].entries){
          var giftDetails = gift_entry.value;
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

  static listenForStatusChangesOfAlreadyCreatedGifts() async {
    var db = RealTimeDatabase.getInstance();
    UserModel user = await CurrentUser.getCurrentUser();
    var ref = db.ref('/users/${user.uid}/friends');
    ref.onChildAdded.listen((event) async {
      print("A friend has added you");
      await showNotification("You have a new Friend!");
    });


    ref = db.ref('/users/${user.uid}/events');
    var snapshot = await ref.get();
    var data = snapshot.value;
    print(data.entries);
    for(var event in data.keys){
      var gifts = data[event]['gifts'];
      for(var gift in gifts.keys){
        ref = db.ref("/users/${user.uid}/events/eventN${data[event]['id'].toString()}/gifts/$gift");
        var gid = data[event]['gifts'][gift]['id'];
        print("EL GID: $gid");
        StreamSubscription sub = ref.onChildChanged.listen((event) async {
          if(event.snapshot.key == "status"){
            if(event.snapshot.value == "2"){
              await showNotification("A friend has bought a gift!");
            }else if(event.snapshot.value == "1"){
              await showNotification("A friend has pledged a gift");
            }
            print("Status Changed");
            var db = await LocalDB.getInstance();
            await db.update(
                'gifts',
                {
                  "status": event.snapshot.value
                },
                where: 'id = ?',
                whereArgs: [gid]
            );
          }
        });

        _subscriptions.add(sub);

      }
    }
  }



  static listenForStatusChanges(DatabaseReference? ref, String gid) async {
    // ref.onChildChanged.listen((event) async {
    //
    //   if(event.snapshot.key == "status"){
    //     print("hi");
    //     if(event.snapshot.value == "2"){
    //       await _showNotification("A friend has bought a gift!");
    //     }else if(event.snapshot.value == "1"){
    //       await _showNotification("A friend has pledged a gift");
    //     }
    //
    //     print("bye");
    //     print("Status Changed");
    //     // print("GIDJKSKFJB<: $gid");
    //     var db = await LocalDB.getInstance();
    //     await db.update(
    //         'gifts',
    //         {
    //           "status": event.snapshot.value
    //         },
    //         where: 'id = ?',
    //         whereArgs: [gid]
    //     );
    //   }
    // });
    //Listen and send FCM Notification
    removeAllListeners();
    await listenForStatusChangesOfAlreadyCreatedGifts();
  }

  static removeAllListeners(){
    for(StreamSubscription subscription in _subscriptions){
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  static Future showNotification(String msg) async {
    print("hi");
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print("hi");

    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'This is a notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      msg,
      platformDetails,
      payload: 'Notification Payload',
    );
  }
}