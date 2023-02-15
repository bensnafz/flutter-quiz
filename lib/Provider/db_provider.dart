import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz/Models/AnsModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._privateConstructor();

  static final DBProvider instance = DBProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AnsDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE Ans(' //สร้างตารามสถานที่
        'id INTEGER PRIMARY KEY,'
        'num_quiz INTEGER,'
        'time_stamp DATETIME,'
        'num_correct INTEGER,'
        'num_incorrect INTEGER,'
        'percent INTEGER,'
        'grade FLOAT,'
        'exam_duration TEXT'
        ')');
  }

  Future<List<Ans>> getAns() async {
    Database db = await instance.database;
    var ans = await db.query('Ans', orderBy: 'id DESC');
    List<Ans> ansList =
        ans.isNotEmpty ? ans.map((a) => Ans.fromJson(a)).toList() : [];
    return ansList;
  }

  Future<List<Ans>> getAnsData() async {
    Database db = await instance.database;
    var ans = await db.query('Ans', orderBy: 'id ASC');
    List<Ans> ansList =
        ans.isNotEmpty ? ans.map((a) => Ans.fromJson(a)).toList() : [];
    return ansList;
  }

  Future<List<Ans>> getAnsbyNumQuiz(int id) async {
    Database db = await instance.database;
    List<Map> ansList = await db.query('Ans',
        where: 'num_quiz = ?', whereArgs: [id], orderBy: 'id');
    // List<Ans> ans =
    //     ansList.isNotEmpty ? ansList.map((e) => Ans.fromJson(e)).toList() : [];
    List<Ans> ans = [];
    if (ansList.isNotEmpty) {
      for (int i = 0; i < ansList.length; i++) {
        ans.add(Ans.fromJson(ansList[i] as Map<String, dynamic>));
      }
    }
    return ans;
  }

  Future<List<Ans>> getAnsMax() async {
    Database db = await instance.database;
    var ans = await db.rawQuery('SELECT *, MAX(num_correct) FROM Ans');
    List<Ans> ansList =
        ans.isNotEmpty ? ans.map((a) => Ans.fromJson(a)).toList() : [];
    return ansList;
  }

  Future<List<Ans>> getAnsMin() async {
    Database db = await instance.database;
    var ans = await db.rawQuery('SELECT *, MIN(num_correct) FROM Ans');
    List<Ans> ansList =
        ans.isNotEmpty ? ans.map((a) => Ans.fromJson(a)).toList() : [];
    return ansList;
  }

  Future<int> add(Ans ans) async {
    Database db = await instance.database;
    return await db.insert('Ans', ans.toJson());
  }

  Future<int> removeAll() async {
    Database db = await instance.database;
    return await db.delete('Ans');
  }
}
