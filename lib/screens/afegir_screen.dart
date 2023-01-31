import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/models/modelo.dart';
import 'package:dogs_db_pseb_bridge/screens/orden_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AfegirGasto extends StatefulWidget {
  const AfegirGasto({Key? key}) : super(key: key);

  @override
  State<AfegirGasto> createState() => _AfegirGastoState();
}

class _AfegirGastoState extends State<AfegirGasto> {

  late int id;
  late String fecha;
  // variables para dropdownlist
  late String categoria;
  late List<String> items2 = ['Festa','Viatge','Nòmina','Capritxo','Regal'];
  late String? selectedItem2 = 'Nòmina';
  // variables para dropdownlist
  late List<String> items = ['Recurrent','Extraordinari'];
  late String? selectedItem = 'Recurrent';
  late String tipo;

  late String concepte;
  late int quantitat;


  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añade gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Fecha del gasto'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce una fecha de gasto';
                    }

                    fecha = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
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
                      hintText: 'Cantidad dinero'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce una cantidad de dinero';
                    }

                    quantitat = int.parse(value);
                    return null;
                  },
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

                const SizedBox(height: 10,),

                ElevatedButton(onPressed: () async {

                  if( formKey.currentState!.validate()){
                    var dbHelper =  DatabaseHelper.instance;
                    dbHelper.setGasto(fecha,categoria,tipo, concepte,quantitat);
                  }


                }, child: const Text('Save')),
                ElevatedButton(onPressed: () async{
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const ListaGasto();
                  }));
                  Gasto().id = null;
                }, child: const Text('View All')),
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
}
