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

  static createGift(name, description, category, price, event_id) async {
    var db = await LocalDB.getInstance();
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
        print(e);
        print("skipping");
      }
    });
    // print(res);
    // print(gifts);

    return gifts;
  }

}