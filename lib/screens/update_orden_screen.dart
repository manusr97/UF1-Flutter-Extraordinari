import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/controlador.dart';
import '../models/modelo.dart';

class Actualizar extends StatefulWidget {
  final Orden orden;

  const Actualizar({Key? key, required this.orden}) : super(key: key);

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  late String fecha;
  late List<String> items = ['Compra','Venta'];
  late String? selectedItem = 'Compra';
  late String tipo;
  late int bitcoin;
  late int euro;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Orden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.orden.fecha,
                  decoration: const InputDecoration(hintText: 'Fecha de orden'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Porfavor introduce una fecha';
                    }

                    fecha = value;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.orden.bitcoin.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introduce los bitcoin'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce cantidad bitcoin';
                    }

                    bitcoin = int.parse(value);
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.orden.euro.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introduce comision en  euros'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce cantidad euros';
                    }

                    euro = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedItem,
                  items: items.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize:15)))).toList(),
                  onChanged: (item) => setState((){
                    selectedItem = item;
                    tipo = item.toString();
                  }),

                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var id = widget.orden.id;
                        var dbHelper = DatabaseHelper.instance;
                        dbHelper.actualizarOrden(id,fecha,tipo,bitcoin,euro);

                        Navigator.pop(context, 'done');
                        //
                        // }
                      }
                    },
                    child: const Text('Actualizar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
