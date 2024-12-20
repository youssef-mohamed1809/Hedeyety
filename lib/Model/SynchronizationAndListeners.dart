import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Event.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/LocalDB.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/UserModel.dart';

class SynchronizationAndListeners {
  static List<StreamSubscription> _subscriptions = [];

  static synchronizeFirebaseWithLocal() async {
    var id = UserModel.getCurrentUserUID();
    var db = RealTimeDatabase.getInstance();
    var ref = db.ref().child('users/$id/events/');
    var snapshot = await ref.get();
    if (snapshot.value == null) {
      return;
    }
    var data = snapshot.value as Map;
    for (var entry in data.entries) {
      var eventDetails = entry.value;

      List<String> parts = eventDetails['date'].split('-');
      String year = parts[0];
      String month = parts[1].padLeft(2, '0');
      String day = parts[2].padLeft(2, '0');
      var date = '$year-$month-$day';
      DateTime d = DateTime.parse(date);

      await Event.createEvent(
        eventDetails['id'],
        eventDetails['name'],
        d,
        eventDetails['location'],
        eventDetails['description'],
      );
      if (eventDetails['gifts'] != null) {
        for (var gift_entry in eventDetails['gifts'].entries) {
          var giftDetails = gift_entry.value;
          await Gift.createGift(
              giftDetails['id'],
              giftDetails['name'],
              giftDetails['description'],
              giftDetails['category'],
              giftDetails['price'],
              eventDetails['id'],
              status: giftDetails['status'],
              imgURL: giftDetails['imgURL']);
        }
      }
    }
  }

  static listenForStatusChangesOfAlreadyCreatedGifts() async {
    var db = RealTimeDatabase.getInstance();
    UserModel user = await CurrentUser.getCurrentUser();

    var ref = db.ref('/users/${user.uid}/friends');

    DataSnapshot friends_snapshot = await ref.get();

    if (friends_snapshot.exists) {
      Map data = friends_snapshot.value as Map;
      data.forEach((friend_id, value) {
        CurrentUser.friends.add(friend_id);
      });
    }
    StreamSubscription sub = ref.onChildAdded.listen((event) async {
      if (!CurrentUser.friends.contains(event.snapshot.key)) {
        await showNotification("You have a new Friend!");
      }
    });

    _subscriptions.add(sub);

    ref = db.ref('/users/${user.uid}/events');
    var snapshot = await ref.get();
    var data = snapshot.value;
    if (data == null) {
      return;
    }
    for (var event in data.keys) {
      var gifts = data[event]['gifts'] ?? null;
      if (gifts == null) {
        continue;
      }
      for (var gift in gifts.keys) {
        ref = db.ref(
            "/users/${user.uid}/events/eventN${data[event]['id'].toString()}/gifts/$gift");
        var gid = data[event]['gifts'][gift]['id'];
        StreamSubscription sub = ref.onChildChanged.listen((event) async {
          if (event.snapshot.key == "status") {
            if (event.snapshot.value == "2") {
              await showNotification("A friend has bought a gift!");
            } else if (event.snapshot.value == "1") {
              await showNotification("A friend has pledged a gift");
            }
            var db = await LocalDB.getInstance();
            await db.update('gifts', {"status": event.snapshot.value},
                where: 'id = ?', whereArgs: [gid]);
          }
        });

        _subscriptions.add(sub);
      }
    }
  }

  static listenForStatusChanges(DatabaseReference? ref, String gid) async {
    StreamSubscription sub = ref!.onChildChanged.listen((event) async {
      if (event.snapshot.key == "status") {
        if (event.snapshot.value == "2") {
          await showNotification("A friend has bought a gift!");
        } else if (event.snapshot.value == "1") {
          await showNotification("A friend has pledged a gift");
        }



        var db = await LocalDB.getInstance();
        await db.update('gifts', {"status": event.snapshot.value},
            where: 'id = ?', whereArgs: [gid]);
      }
    });
    _subscriptions.add(sub);
  }

  static removeAllListeners() {
    for (StreamSubscription subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  static Future showNotification(String msg) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
