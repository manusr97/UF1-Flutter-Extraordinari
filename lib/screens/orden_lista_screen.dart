import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/screens/update_orden_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/modelo.dart';

class ListaOrden extends StatefulWidget {
  const ListaOrden({Key? key}) : super(key: key);

  @override
  State<ListaOrden> createState() => _ListaOrdenState();
}

class _ListaOrdenState extends State<ListaOrden> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras/Ventas'),
      ),
      body: FutureBuilder<List<Orden>>(
        future: DatabaseHelper.instance.getAllOrden(),
        builder: (BuildContext context, AsyncSnapshot<List<Orden>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No Orden Found in Database'));
            } else {
              List<Orden> ordenes = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: ordenes.length,
                    itemBuilder: (context, index) {
                      Orden orden = ordenes[index];
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
                                          orden.fecha,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text('Tipo: ${orden.tipo}'),
                                        Text('Bitcoin: ${orden.bitcoin}'),
                                        Text('Euros: ${orden.euro}')
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
                                              return Actualizar(orden: orden);
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

                                                            // delete orden

                                                            int result =
                                                                await DatabaseHelper
                                                                    .instance
                                                                    .deleteOrden(
                                                                        orden.id!);

                                                            if (result > 0) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'orden Deleted');
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
