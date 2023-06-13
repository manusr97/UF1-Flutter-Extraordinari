import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/modelo.dart';

class DatabaseHelper {

  DatabaseHelper._privateConstructor(); // Name constructor to create instance of database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/coche.db';

    var gastoDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return gastoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE coche (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  fecha INTEGER,
                  km INTEGER,
                  tipo TEXT,
                  concepte TEXT,
                  quantitat INTEGER )
    
    ''');
  }
  void setGasto(fecha,km,tipo,concepte,quantitat){
    Gasto().setGasto2(fecha,km, tipo,concepte,quantitat);
    insertGasto(Gasto());
  }
  void actualizarGasto(id,fecha,km,tipo,concepte,quantitat){
    Gasto().updateGasto(id,fecha,km,tipo,concepte,quantitat);
    updateGasto(Gasto());
  }
  Future<int> insertGasto(Gasto gasto) async {

    Database db = await instance.database;
    int result = await db.insert('coche', gasto.toMap());
    return result;
  }

  Future<List<Gasto>> getAllGasto() async {
    List<Gasto> gastos = [];

    Database db = await instance.database;

    List<Map<String, dynamic>> listMap = await db.query('coche');

    for (var gastoMap in listMap) {
      Gasto gasto = Gasto.fromMap(gastoMap);
      gastos.add(gasto);

    }

    return gastos;
  }


  // delete
  Future<int> deleteGasto(int id) async {
    Database db = await instance.database;
    int result = await db.delete('coche', where: 'id=?', whereArgs: [id]);
    return result;
  }

  // update
  Future<int> updateGasto(Gasto gasto) async {
    Database db = await instance.database;
    int result = await db.update('coche', gasto.toMap(), where: 'id=?', whereArgs: [gasto.id]);
    return result;
  }

}
