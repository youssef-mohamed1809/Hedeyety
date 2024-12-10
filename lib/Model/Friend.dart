import 'package:hedeyety/Model/RTdb.dart';

class Friend{
  String? id;
  String? name;
  List<Map>? events;

  static Future getFriendDetails(id) async{
    var db = RealTimeDatabase.getInstance();

    var ref = db.ref().child("users/$id");
    try {
      var snapshot = await ref.get();
      Map friend = snapshot.value as Map;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}