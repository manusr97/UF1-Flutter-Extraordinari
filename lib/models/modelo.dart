class Gasto {
  int? id;
  late String fecha;
  late String categoria;
  late String tipo;
  late String concepte;
  late int quantitat;

  static final Gasto _modelo = Gasto._internal();
  factory Gasto(){
    return _modelo;
  }
  Gasto._internal();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'categoria': categoria,
      'tipo': tipo,
      'concepte': concepte,
      'quantitat': quantitat,

    };
  }

  // Convert a Map to a Dog Object
  Gasto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fecha = map['fecha'];
    categoria = map['categoria'];
    tipo = map['tipo'];
    concepte = map['concepte'];
    quantitat = map['quantitat'];
  }
  void updateGasto(int _id,String _fecha,String _categoria,String _tipo,String _concepte,int _quantitat){
    id = _id;
    fecha = _fecha;
    categoria = _categoria;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
  }
  void setGasto2(String _fecha,String _categoria,String _tipo,String _concepte,int _quantitat){
    fecha = _fecha;
    categoria = _categoria;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
  }
}
