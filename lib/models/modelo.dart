class Orden {
  int? id;
  late String fecha;
  late String tipo;
  late int bitcoin;
  late int euro;

  static final Orden _modelo = Orden._internal();
  factory Orden(){
    return _modelo;
  }
  Orden._internal();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'tipo': tipo,
      'bitcoin': bitcoin,
      'euro': euro,

    };
  }

  // Convert a Map to a Dog Object
  Orden.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fecha = map['fecha'];
    tipo = map['tipo'];
    bitcoin = map['bitcoin'];
    euro = map['euro'];
  }
  void updateOrden2(int _id,String _fecha,String _tipo,int _bitcoin,int _euro){
    id = _id;
    fecha = _fecha;
    tipo = _tipo;
    bitcoin = _bitcoin;
    euro = _euro;
  }
  void setOrden2(String _fecha,String _tipo,int _bitcoin,int _euro){
    fecha = _fecha;
    tipo = _tipo;
    bitcoin = _bitcoin;
    euro = _euro;
  }
}
