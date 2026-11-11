import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class ContactRepository {
  static Future<Database> _getDatabase() async {
    final database = await openDatabase(
      'contact_manager.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            phone TEXT,
            address TEXT
          )
        ''');

      },
    );

    return database;
  }

  static Future<List<Contact>> getContacts() async {
    final db = await _getDatabase();
    final result = await db.query('contacts');
    return result.map((json) => Contact.fromMap(json)).toList();
  }

  static Future<int> addContact(Contact contact) async {
    final db = await _getDatabase();
    return await db.insert('contacts', contact.toMap());
  }

  static Future<int> updateContact(Contact contact) async {
    final db = await _getDatabase();
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  static Future<int> deleteContact(int id) async {
    final db = await _getDatabase();
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
