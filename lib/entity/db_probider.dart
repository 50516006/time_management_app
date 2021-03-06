
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'models.dart';

class DBProvider{
    DBProvider._();
    static final DBProvider db = DBProvider._();
    static Database _database;
    static final _didTable = "Did";
    static final _typeTable = "DType";

    Future<Database> get database async{
      if(_database != null){
        return _database;
      }

      _database =await initDB();
      return _database;
      }

     Future<Database> initDB() async{

        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        String path= join(documentsDirectory.path,"time_managemaent_app.db");

        return await openDatabase(path,version: 1,onCreate: _createTable);

     }


    Future<void> _createTable(Database db,int version) async{

        await db.execute(
        "CREATE TABLE Did("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "type INTEGER,"
        "start TEXT,"
        "end TEXT"
        ")");

       return await db.execute(
         "CREATE TABLE DType("
         "id INTEGER PRIMARY KEY AUTOINCREMENT,"
         "red INTEGER,green INTEGER,blue INTEGER,"
        "name TEXT UNIQUE)"
       );

    }


    createDid(Did did)async{
      final db = await database;
      var responce = await db.insert(_didTable, did.toMapWithoutId());
      return responce;
    }

    getAllDid() async{
      final db = await database;
      var res = await db.query(_didTable);
      List<Did> list =
          res.isNotEmpty ? res.map((c) => Did.fromMap(c)).toList() : [];
          return list;
    }

    updateDid(Did did) async {
      final db = await database;
      var res = await db.update(_didTable,
      did.toMap(),
      where: "id = ?",
      whereArgs: [did.id]
      );
      return res;
    }

    deleteDid(int id) async{
      final db = await database;
      var res = db.delete(
        _didTable,
        where: "id = ?",
        whereArgs:[id]
      );
      return res;
    }





    createType(DType dtype) async{

      final db = await database;
      var res = db.insert(_typeTable, dtype.toMapWithoutId());
      return res;
    }

    Future<List<DType>> getAllTypes() async{
      final db = await database;
      var res = await db.query(_typeTable);
      List<DType> list = res.isNotEmpty ? res.map((c) => DType.fromMap(c)).toList() : [];
      debugPrint("$list");
      return list;
    }



    updateType(DType dtype) async {

      final db = await database;
      var res = await db.update(_typeTable,
      dtype.toMap(),
      where: "id = ?",
      whereArgs: [dtype.id]
      );
      return res;
    }

    deleteType(int id) async{
      final db = await database;
      var res = db.delete(
        _typeTable,
        where: "id = ?",
        whereArgs:[id]
      );
      return res;
    }




}