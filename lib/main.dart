import 'package:dogs_db_pseb_bridge/screens/afegir_screen.dart';
import 'package:dogs_db_pseb_bridge/screens/orden_lista_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const ListaGasto(),
    );
  }
}
