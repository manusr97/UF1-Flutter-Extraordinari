import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/screens/update_orden_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/modelo.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'afegir_screen.dart';

class ListaGasto extends StatefulWidget {
  const ListaGasto({Key? key}) : super(key: key);

  @override
  State<ListaGasto> createState() => _ListaGastoState();
}

class _ListaGastoState extends State<ListaGasto> {
  String? selectedCategory;
  List<Gasto> gastos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<List<Gasto>> _loadData() async {
    List<Gasto> data = await DatabaseHelper.instance.getAllGasto();
    setState(() {
      gastos.clear(); // Clear the existing data
      gastos.addAll(data); // Add the new data
    });
    return data;
  }



  List<GastoData> getChartData() {
    return gastos
        .map((gasto) => GastoData(gasto.km, gasto.fecha))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de despeses'),
      ),
      body: FutureBuilder<List<Gasto>>(
        future: _loadData(),
        builder: (BuildContext context, AsyncSnapshot<List<Gasto>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No Orden Found in Database'));
            } else {
              List<Gasto> gastos = snapshot.data!;
              List<String> categories =
              gastos.map((gasto) => gasto.tipo).toSet().toList();
              categories.insert(0, 'Todos'); // Agregar la opción 'Todos' al inicio de la lista de categorías

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text('Seleccione una categoría'),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: gastos.length,
                        itemBuilder: (context, index) {
                          Gasto gasto = gastos[index];
                          if (selectedCategory != null &&
                              selectedCategory != 'Todos' &&
                              gasto.tipo != selectedCategory) {
                            return Container(); // No mostrar el elemento si no coincide con la categoría seleccionada
                          }
                          return Card(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  gasto.fecha)),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text('Km: ${gasto.km}'),
                                        Text('Tipo: ${gasto.tipo}'),
                                        Text('Concepte: ${gasto.concepte}'),
                                        Text('quantitat: ${gasto.quantitat}'),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          var result =
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) {
                                              return Actualizar(gasto: gasto);
                                            }),
                                          );

                                          if (result == 'done') {
                                            _loadData(); // Actualizar los datos después de editar
                                          }
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Confirmation!'),
                                                content: const Text(
                                                    'Are you sure to delete?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();

                                                      // delete gasto
                                                      int result =
                                                      await DatabaseHelper
                                                          .instance
                                                          .deleteGasto(
                                                          gasto.id!);

                                                      if (result > 0) {
                                                        Fluttertoast.showToast(
                                                          msg: 'Gasto deleted',
                                                        );
                                                        _loadData(); // Actualizar los datos después de eliminar
                                                      }
                                                    },
                                                    child: const Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AfegirGasto()),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class GastoData {
  final int? km;
  final int? days;

  GastoData(this.km, int timestamp)
      : days = DateTime.fromMillisecondsSinceEpoch(timestamp)
      .difference(DateTime.now())
      .inDays
      .abs();
}