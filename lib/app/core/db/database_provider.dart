

import 'dart:io';
import 'package:notes_app/app/core/utils/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseProvider{

  DatabaseProvider._internal();

  static final DatabaseProvider dbProvider=DatabaseProvider._internal();

  Database? database;

  static DatabaseProvider get instance => dbProvider;

  Future<Database> get db async{
    if(database!=null)
    {
      return database!;
    }
    else
    {
      database =await createDatabase();
      return database!;
    }
  }


  Future<Database> createDatabase() async{
    Directory docDirectory=await getApplicationDocumentsDirectory();
    String path=join(docDirectory.path,DbConstant.dbName);
    var database=await openDatabase(path,version: DbConstant.databaseVersion,onCreate: _onCreate ,onUpgrade: _onUpgrade);
    return database;
  }
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE Table ${DbConstant.tableName} (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    title TEXT,
    subTitle TEXT,
    isLock INTEGER,
    timeStamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''');
  }
  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Directory docDirectory=await getApplicationDocumentsDirectory();
    String path=join(docDirectory.path,DbConstant.dbName);
    await deleteDatabase(path);
  }
}