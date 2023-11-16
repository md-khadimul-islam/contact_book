
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DatabaseHelper {
  Database? database;

  Future<void> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'contacts.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phoneNumber TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertContact(Contact contact) async {
    await database!.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final List<Map<String, dynamic>> maps = await database!.query('contacts');
    return List.generate(maps.length, (i) {
      return Contact(
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
      );
    });
  }
}
