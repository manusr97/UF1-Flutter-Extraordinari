import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/models/modelo.dart';
import 'package:dogs_db_pseb_bridge/screens/orden_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AfegirOrden extends StatefulWidget {
  const AfegirOrden({Key? key}) : super(key: key);

  @override
  State<AfegirOrden> createState() => _AfegirOrdenState();
}

class _AfegirOrdenState extends State<AfegirOrden> {

  late int id;
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
        title: const Text('Añade Orden'),
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
                    hintText: 'Fecha de la orden'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce una fecha de orden';
                    }

                    fecha = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                /*TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Tipo de orden (compra/venta)'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce un tipo de orden';
                    }

                    tipo = value;
                    return null;
                  },
                ),
*/

                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Cantidad de bitcoins'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce una cantidad de bitcoins';
                    }

                    bitcoin = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Cantidad de comision (€)'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Porfavor introduce una cantidad de comision (€)';
                    }

                    euro = int.parse(value);
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
                    dbHelper.setOrden(fecha,tipo, bitcoin,euro);
                  }


                }, child: const Text('Save')),
                ElevatedButton(onPressed: () async{
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const ListaOrden();
                  }));
                  Orden().id = null;
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
