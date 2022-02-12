import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? db;
  static int dbVersion = 1;

  //database operations
  static Future<void> insert({dynamic model, String? table}) async {
    await db?.insert(table!, model.toMap());
  }

  static Future<void> update({dynamic model, String? table, String? where, List<dynamic>? whereArgs}) async {
    await db?.update(table!, model.toMap(), where: where, whereArgs: whereArgs);
  }

  static Future<void> delete({String? table, String? where, List<dynamic>? whereArgs}) async {
    await db?.delete(table!, where: where, whereArgs: whereArgs);
  }

  static Future<int?> getEmployeeCount({String? query}) async {
    return Sqflite.firstIntValue(await db!.rawQuery(query!));
  }

  //database setup functions
  static Future<String> getPath({String? dbName}) async {
    final path = await getDatabasesPath();
    return join(path, dbName);
  }

  //gamit to pang create ng table
  static Future<void> onCreate(Database? db, int? version) async {
    await db?.execute('CREATE TABLE employee (id INT, name TEXT, job TEXT)');
  }

  //pang start ng database
  static Future<void> initializeDatabase() async {
    db = await openDatabase(
      await getPath(dbName: 'employee_db'),
      version: dbVersion,
      onCreate: onCreate,
    );
    print('Initializing Database: $db');
  }
}
