import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/models/modelo.dart';
import 'package:dogs_db_pseb_bridge/screens/orden_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class AfegirGasto extends StatefulWidget {
  const AfegirGasto({Key? key}) : super(key: key);

  @override
  State<AfegirGasto> createState() => _AfegirGastoState();
}

class _AfegirGastoState extends State<AfegirGasto> {

  late int id;
  late DateTime selectedDate = DateTime.now();

  // variables para dropdownlist
  late int km;
  late List<String> items2 = ['Combustible','Avaria','Assegurança','Equipament','Altres'];
  late String? selectedItem2 = 'Combustible';
  // variables para dropdownlist
  //late List<String> items = ['Recurrent','Extraordinari'];
  //late String? selectedItem = 'Recurrent';
  late String tipo = 'Combustible';

  late String concepte;
  late int quantitat;


  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añade coche'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector( // Utilizamos GestureDetector para detectar el evento de toque
                  onTap: () => _selectDate(context), // Llamamos a la función _selectDate cuando se toca el campo
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Fecha'
                      ),
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'
                            : '',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor introduce una fecha';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                DropdownButton<String>(
                  value: selectedItem2,
                  items: items2.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize:15)))).toList(),
                  onChanged: (item) => setState((){
                    selectedItem2 = item;
                    tipo = item.toString();
                  }),

                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Concepte del gasto'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce un concepte de gasto';
                    }
                    concepte = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Cantidad'
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Solo permite ingresar dígitos
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduce una cantidad';
                    }

                    quantitat = int.parse(value);
                    return null;
                  },
                ),

                const SizedBox(height: 10,),

                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Cantidad Kilometros'
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Solo permite ingresar dígitos
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduce Kilometros';
                    }

                    km = int.parse(value);
                    return null;
                  },
                ),
                // DropdownButton<String>(
                //     value: selectedItem,
                //     items: items.map((item) => DropdownMenuItem<String>(
                //         value: item,
                //     child: Text(item, style: TextStyle(fontSize:15)))).toList(),
                //   onChanged: (item) => setState((){
                //     selectedItem = item;
                //     tipo = item.toString();
                //   }),
                //
                // ),

                const SizedBox(height: 10,),

                ElevatedButton(onPressed: () async {

                  if( formKey.currentState!.validate()){
                    var dbHelper =  DatabaseHelper.instance;
                    int unixTimestamp = selectedDate.millisecondsSinceEpoch;
                    dbHelper.setGasto(unixTimestamp,km,tipo, concepte,quantitat);

                  }

                  Navigator.pop(context, 'done');
                }, child: const Text('Save')),

                /*ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return Graph();
                  }));
                }, child: const Text('Ver grafico')),*/

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
