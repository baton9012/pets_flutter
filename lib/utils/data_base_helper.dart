import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:petsflutter/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'user_table';
  String colId = 'id';
  String colName = 'name';
  String colLastname = 'lastname';
  String colMail = 'mail';
  String colNumpet = 'numpet';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initialDatabase();
    }

    return _database;
  }

  Future<Database> initialDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'user.db';

    var userDatabase = await openDatabase(path, version: 1, onCreate: _createDb);

    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $userTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colLastname TEXT, $colMail TEXT, $colNumpet INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    var result = await db.query(userTable);
    return result;
  }

  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.rawInsert('INSERT INTO $userTable($colName, $colLastname, $colMail, $colNumpet) VALUES (\'${user.name}\', \'${user.lastname}\', \'${user.mail}\', \'${user.numpet}\')');
    return result;
  }

  Future<int> updateUser(User user) async {
    var db = await this.database;
    var result = await db.rawUpdate('UPDATE $userTable SET $colName = \'${user.name}\', $colLastname = \'${user.lastname}\', $colMail = \'${user.mail}\' WHERE $colId  = ${user.id}');
  }

  Future<int> deleteUser(int id) async {
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $userTable WHERE $colId = $id');
    return result;
  }

  Future<List<User>> getUserList() async {
    var userMapList = await getUserMapList();
    int count = userMapList.length;

    List<User> userList = List<User>();

    for(int i = 0; i < count; i++) {
      userList.add(User.formMapObject(userMapList[i]));
    }

    return userList;
  }
}