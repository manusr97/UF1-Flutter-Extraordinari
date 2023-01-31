import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/controlador.dart';
import '../models/modelo.dart';

class Actualizar extends StatefulWidget {
  final Gasto gasto;

  const Actualizar({Key? key, required this.gasto}) : super(key: key);

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  late String fecha;
  // variables para dropdownlist
  String? categoria;
  late List<String> items2 = ['Festa','Viatge','Nòmina','Capritxo','Regal'];
  late String? selectedItem2 = 'Nòmina';
  // variables para dropdownlist
  late List<String> items = ['Recurrent','Extraordinari'];
  late String? selectedItem = 'Recurrent';
  String? tipo;

  late String concepte;
  late int quantitat;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.gasto.fecha,
                  decoration: const InputDecoration(hintText: 'Fecha de gasto'),
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
                  initialValue: widget.gasto.concepte,
                  decoration: const InputDecoration(hintText: 'Introduce el concepte'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce concepte';
                    }

                    concepte = value;
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.gasto.quantitat.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introduce cantidad'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce cantidad';
                    }

                    quantitat = int.parse(value);
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
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedItem2,
                  items: items2.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize:15)))).toList(),
                  onChanged: (item) => setState((){
                    selectedItem2 = item;
                    categoria = item.toString();
                  }),

                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var id = widget.gasto.id;
                        var dbHelper = DatabaseHelper.instance;
                        dbHelper.actualizarGasto(id,fecha,categoria,tipo,concepte,quantitat);

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
