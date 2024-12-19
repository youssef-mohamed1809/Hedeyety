import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static var db;

  static getInstance() async {
    db ??= openDatabase(join(await getDatabasesPath(), 'hedeyety.db'),
          onCreate: (db, version) async {
        print("Creating Local DB");
        await db.execute('CREATE TABLE events ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'date TEXT NOT NULL,'
            'location TEXT,'
            'description TEXT,'
            'published INTEGER NOT NULL'
            ');');
        await db.execute('CREATE TABLE gifts('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'description TEXT,'
            'category INT NOT NULL,'
            'price REAL NOT NULL,'
            'event_id INT NOT NULL,'
            'status INT NOT NULL,'
            'FOREIGN KEY (event_id) REFERENCES events(id)'
            ');');
        await db.execute('CREATE TABLE category('
            'id INTEGER PRIMARY KEY,'
            'category TEXT UNIQUE'
            ');');

        await db.execute(
          'INSERT INTO category (id, category) VALUES'
            '(1, \'Clothing and Accessories\'),'
            '(2, \'Electronics and Gadgets\'),'
            '(3, \'Home and Living\'),'
            '(4, \'Toys and Games\'),'
            '(5, \'Books and Stationery\'),'
            '(6, \'Personal Care and Wellness\'),'
            '(7, \'Hobbies and Interests\'),'
            '(8, \'Gift Cards\');'
        );
      }, version: 1);

    return db;
  }
}
