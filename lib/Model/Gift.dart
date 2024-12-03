import 'RTdb.dart';
import 'LocalDB.dart';
import 'package:sqflite/sqflite.dart';

class Gift{

  String? id;
  String? description;
  String? category;
  String? price;
  String? pledged;
  String? name;

  Gift({this.id, this.name, this.description, this.category, this.price, this.pledged});

  static createGift(name, description, category, price, event_id) async {
    var db = await LocalDB.getInstance();
    await db.insert(
        'gifts',
        {
          'name': name,
          'description': description,
          'price': price,
          'category': category,
          'pledged': 0,
          'event_id': event_id,
          'status': 0
        },
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  static getLocalGifts(event_id) async {
    var db = await LocalDB.getInstance();
    List<Map> res = await db.rawQuery("select * from gifts");
    List gifts = [];

    res.forEach((row){

      try{
        gifts.add(Gift(
          id: row['id'].toString(),
          name: row['name'],
          description: row['description'],
            category: row['category'].toString(),
            price: row['price'].toString(),
            pledged: row['pledged'].toString()
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