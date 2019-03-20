import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_multi_textfield/database/model/Contact.dart';
import 'package:flutter_multi_textfield/database/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, dob TEXT)");
    await db.execute("CREATE TABLE Contact(id INTEGER PRIMARY KEY, adresse TEXT, date TEXT, etat TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }
  // save contact
  Future<int> saveContact(Contact contact) async {
    var dbClient = await db;
    int res = await dbClient.insert("Contact", contact.toMap());
    return res;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var user =
          new User(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    print(employees.length);
    return employees;
  }
  // add get contact list
  Future<List<Contact>> getContact() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Contact');
    List<Contact> contactlist = new List();
    for (int i = 0; i < list.length; i++) {
      var conatct =  new Contact(list[i]["adresse"], list[i]["date"], list[i]["etat"]);
      conatct.setContactId(list[i]["id"]);
      contactlist.add(conatct);
//      contactlist.forEach((f){
//        print(f.adresse+" / "+f.date);
//      });
    }
//    print("---list----");
//    print(contactlist.toString());
//    print(contactlist.length);
//    print("---list----");

    return contactlist;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    return res;
  }
  // delete contact
  Future<int> deleteContact(Contact contact) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM Contact WHERE id = ?', [contact.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res =   await dbClient.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);



    return res > 0 ? true : false;
  }

  // Delete contact
  Future<bool> updateContact(Contact contact) async {
    var dbClient = await db;
    print("+++ id +++");
    print(contact.id);
    print("+++ id +++");
    int res =   await dbClient.update("Contact", contact.toMap(),
        where: "id = ?", whereArgs: <int>[contact.id]);
    return res > 0 ? true : false;
  }
}
