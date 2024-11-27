import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static var db;

  static getInstance() async {
    if (db == null) {
      db = openDatabase(join(await getDatabasesPath(), 'hedeyety.db'),
          onCreate: (db, version) {
        return db.execute('CREATE TABLE events ('
            'id integer primary key autoincrement,'
            'name varchar(255) not null,'
            'date varchar(255),'
            'location varchar(255),'
            'description varchar(255)'
            ');'
            'CREATE TABLE gifts('
            'id integer primary key autoincrement,'
            ''
            ')');
      },
      version: 1
      );
    }

    return db;
  }
}
