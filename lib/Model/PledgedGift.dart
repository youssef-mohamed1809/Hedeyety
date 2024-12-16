import 'package:hedeyety/CurrentUser.dart';
import 'package:hedeyety/Model/Gift.dart';
import 'package:hedeyety/Model/RTdb.dart';
import 'package:hedeyety/Model/UserModel.dart';

class PledgedGift extends Gift {
  String pledgedGiftId;
  String giftRequesterID;
  String eventID;

  PledgedGift(
      {required id,
      required name,
      required description,
      required category,
      required price,
      required status,
      required this.giftRequesterID,
      required this.eventID,
      required this.pledgedGiftId})
      : super(
            id: id,
            name: name,
            description: description,
            category: category,
            price: price,
            status: status);

  static getPledgedGifts() async {
    var db = RealTimeDatabase.getInstance();
    UserModel user = CurrentUser.user!;
    var ref = db.ref().child("users/${user.uid}/pledgedGifts");
    try {
      var snapshot = await ref.get();
      var data = snapshot.value;
      if(data == null){
        return [];
      }
      var gifts = [];
      for (var gift in data.keys) {
        gifts.add(PledgedGift(
            id: data[gift]['id']??"",
            name: data[gift]['name']??"",
            description: data[gift]['description']??"",
            category: data[gift]['category']??"",
            price: data[gift]['price']??"",
            status: data[gift]['status']??"",
            giftRequesterID: data[gift]['giftRequesterId'],
            eventID: (data[gift]['eventId']).toString()??"",
            pledgedGiftId: data[gift]['pledgedGiftId']
        ));
      }

      return gifts;
    } catch (e) {
      print("From getPledgedGifts");
      print(e);
    }
  }

  updateStatus(status) async {

    var db = RealTimeDatabase.getInstance();
    if(status == "2"){


      var ref = db.ref().child("users/${CurrentUser.user!.uid}/pledgedGifts/$pledgedGiftId/");
      await ref.update({"status": status});
      ref = db.ref().child("users/$giftRequesterID/events/eventN$eventID/gifts/giftN$id/");

      await ref.update({"status": status});
    }else if(status == "0"){

    var ref = db.ref();

    await ref.child("users/${CurrentUser.user!.uid}/pledgedGifts/$pledgedGiftId").remove();

    ref = db.ref().child("users/$giftRequesterID/events/eventN$eventID/gifts/giftN$id/");

    await ref.update({"status": status});

    }

  }
}
