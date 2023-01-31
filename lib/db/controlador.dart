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
    String path = '${directory.path}/gasto.db';

    var gastoDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return gastoDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE gasto (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  fecha TEXT,
                  categoria TEXT,
                  tipo TEXT,
                  concepte TEXT,
                  quantitat INTEGER )
    
    ''');
  }
  void setGasto(fecha,categoria,tipo,concepte,quantitat){
    Gasto().setGasto2(fecha,categoria, tipo,concepte,quantitat);
    insertGasto(Gasto());
  }
  void actualizarGasto(id,fecha,categoria,tipo,concepte,quantitat){
    Gasto().updateGasto(id, fecha,categoria,tipo,concepte,quantitat);
    updateGasto(Gasto());
  }
  Future<int> insertGasto(Gasto gasto) async {

    Database db = await instance.database;
    int result = await db.insert('gasto', gasto.toMap());
    return result;
  }

  Future<List<Gasto>> getAllGasto() async {
    List<Gasto> gastos = [];

    Database db = await instance.database;

    List<Map<String, dynamic>> listMap = await db.query('gasto');

    for (var gastoMap in listMap) {
      Gasto gasto = Gasto.fromMap(gastoMap);
      gastos.add(gasto);

    }

    return gastos;
  }


  // delete
  Future<int> deleteGasto(int id) async {
    Database db = await instance.database;
    int result = await db.delete('gasto', where: 'id=?', whereArgs: [id]);
    return result;
  }

  // update
  Future<int> updateGasto(Gasto gasto) async {
    Database db = await instance.database;
    int result = await db.update('gasto', gasto.toMap(), where: 'id=?', whereArgs: [gasto.id]);
    return result;
  }

}
