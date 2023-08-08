import 'dart:developer';

import 'package:notes_app/app/core/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/NoteModel.dart';
import 'database_provider.dart';

class DatabaseController{

  final dbClient=DatabaseProvider.dbProvider;

  Future<int> createNoteRow(NoteModel b) async{
    final db=await dbClient.db;
    var result=await db.insert(DbConstant.tableName, b.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<NoteModel>> getAllNotes({List<String>? columns})async{
    final db=await dbClient.db;
    var result=await db.query(DbConstant.tableName,columns:columns ,orderBy: "id DESC");
    List<NoteModel> notes=result.isNotEmpty ?result.map((e) => NoteModel.fromMap(e)).toList():[];
    return notes;
  }

  Future<NoteModel> searchNote(int id)async{
    final db=await dbClient.db;
    var result=await db.query(DbConstant.tableName,where: "id=?",whereArgs: [id] );
    List<NoteModel> notes=result.isNotEmpty ?result.map((e) => NoteModel.fromMap(e)).toList():[];
    return notes.first;
  }

  Future<int> updateNoteRow(NoteModel b)async{
    final db=await dbClient.db;
    var result=await db.update(DbConstant.tableName, b.toMap(),where: "id=?",whereArgs: [b.dbId]);
    return result;
  }
  Future<int> deleteNoteRow(int id)async{
    final db=await dbClient.db;
    var result=await db.delete(DbConstant.tableName,where: "id=?",whereArgs: [id]);
    return result;
  }
}