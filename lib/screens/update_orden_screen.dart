import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/controlador.dart';
import '../models/modelo.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

class Actualizar extends StatefulWidget {
  final Gasto gasto;

  const Actualizar({Key? key, required this.gasto}) : super(key: key);

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  DateTime? fecha;
  // variables para dropdownlist
  int? km;
  late List<String> items2 = ['Combustible','Avaria','Assegurança','Equipament','Altres'];
  late String? selectedItem2 = 'Combustible';
  // variables para dropdownlist
  // late List<String> items = ['Recurrent', 'Extraordinari'];
  // late String? selectedItem = 'Recurrent';
  String? tipo;

  late String concepte = ''; // Inicialización de concepte con un valor vacío
  late int quantitat=0;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fecha = DateTime.fromMillisecondsSinceEpoch(widget.gasto.fecha);
    concepte = widget.gasto.concepte;
    quantitat = widget.gasto.quantitat;
    tipo = widget.gasto.tipo;
    km = widget.gasto.km;
  }

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
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: fecha!,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        fecha = selectedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: fecha != null ? DateFormat('dd-MM-yyyy').format(fecha!) : '',
                  ),
                  decoration: const InputDecoration(hintText: 'Fecha de gasto'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce una fecha';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: concepte,
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
                  initialValue: quantitat.toString(),
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
                TextFormField(
                  initialValue: km.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introduce Km'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce cantidad';
                    }

                    km = int.parse(value);
                    return null;
                  },
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // DropdownButton<String>(
                //   value: selectedItem,
                //   items: items.map(
                //         (item) => DropdownMenuItem<String>(
                //       value: item,
                //       child: Text(item, style: const TextStyle(fontSize: 15)),
                //     ),
                //   ).toList(),
                //   onChanged: (item) => setState(() {
                //     selectedItem = item;
                //     tipo = item.toString();
                //   }),
                // ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: selectedItem2,
                  items: items2.map(
                        (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 15)),
                    ),
                  ).toList(),
                  onChanged: (item) => setState(() {
                    selectedItem2 = item;
                    tipo = item.toString();
                  }),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var id = widget.gasto.id;
                      var dbHelper = DatabaseHelper.instance;
                      int? unixTimestamp = fecha?.millisecondsSinceEpoch;
                      dbHelper.actualizarGasto(id, unixTimestamp, km, tipo, concepte, quantitat);

                      Navigator.pop(context, 'done');
                    }
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}