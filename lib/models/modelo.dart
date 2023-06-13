class Gasto {
  int? id;
  late int fecha;
  late int? km;
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
      'km': km,
      'tipo': tipo,
      'concepte': concepte,
      'quantitat': quantitat,

    };
  }

  // Convert a Map to a Dog Object
  Gasto.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    fecha = map['fecha'];
    km = map['km'];
    tipo = map['tipo'];
    concepte = map['concepte'];
    quantitat = map['quantitat'];
  }
  void updateGasto(int _id,int _fecha,int _km,String _tipo,String _concepte,int _quantitat){
    id = _id;
    fecha = _fecha;
    km = _km;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
  }
  void setGasto2(int _fecha,int _km,String _tipo,String _concepte,int _quantitat){
    fecha = _fecha;
    km = _km;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
  }
}
