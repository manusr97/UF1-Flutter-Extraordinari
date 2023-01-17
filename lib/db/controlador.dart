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
    String path = '${directory.path}/orden.db';

    var ordenDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return ordenDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE orden (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  fecha TEXT,
                  tipo TEXT,
                  bitcoin INTEGER,
                  euro INTEGER )
    
    ''');
  }
  void setOrden(fecha,tipo,bitcoin,euro){
    Orden().setOrden2(fecha, tipo,bitcoin,euro);
    insertOrden(Orden());
  }
  void actualizarOrden(id,fecha,tipo,bitcoin,euro){
    Orden().updateOrden2(id, fecha,tipo,bitcoin,euro);
    updateOrden(Orden());
  }
  Future<int> insertOrden(Orden orden) async {

    Database db = await instance.database;
    int result = await db.insert('orden', orden.toMap());
    return result;
  }

  Future<List<Orden>> getAllOrden() async {
    List<Orden> ordenes = [];

    Database db = await instance.database;

    List<Map<String, dynamic>> listMap = await db.query('orden');

    for (var ordenMap in listMap) {
      Orden orden = Orden.fromMap(ordenMap);
      ordenes.add(orden);
    }

    return ordenes;
  }


  // delete
  Future<int> deleteOrden(int id) async {
    Database db = await instance.database;
    int result = await db.delete('orden', where: 'id=?', whereArgs: [id]);
    return result;
  }

  // update
  Future<int> updateOrden(Orden orden) async {
    Database db = await instance.database;
    int result = await db.update('orden', orden.toMap(), where: 'id=?', whereArgs: [orden.id]);
    return result;
  }

}
