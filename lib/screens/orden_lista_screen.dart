import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/screens/update_orden_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/modelo.dart';

class ListaGasto extends StatefulWidget {
  const ListaGasto({Key? key}) : super(key: key);

  @override
  State<ListaGasto> createState() => _ListaGastoState();
}

class _ListaGastoState extends State<ListaGasto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gastos'),
      ),
      body: FutureBuilder<List<Gasto>>(
        future: DatabaseHelper.instance.getAllGasto(),
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
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: gastos.length,
                    itemBuilder: (context, index) {
                      Gasto gasto = gastos[index];
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
                                          gasto.fecha,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text('Tipo: ${gasto.tipo}'),
                                        Text('Categoria: ${gasto.categoria}'),
                                        Text('Concepte: ${gasto.concepte}'),
                                        Text('quantitat: ${gasto.quantitat}')
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            var result =
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) {
                                              return Actualizar(gasto: gasto);
                                            }));

                                            if (result == 'done') {
                                              setState(() {});
                                            }
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirmation!'),
                                                    content: const Text(
                                                        'Are you sure to delete ?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('No')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            // delete gasto

                                                            int result =
                                                                await DatabaseHelper
                                                                    .instance
                                                                    .deleteGasto(
                                                                        gasto.id!);

                                                            if (result > 0) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'gasto Deleted');
                                                              setState(() {});
                                                              // build function will be called
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ],
                                  )
                                ],
                              )));
                    }),
              );
            }
          }
        },
      ),
    );
  }
}
