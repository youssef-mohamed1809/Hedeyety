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
        await db.execute('CREATE TABLE category_enum('
            'id INTEGER PRIMARY KEY,'
            'category TEXT UNIQUE'
            ');');
      }, version: 1);

    return db;
  }
}
