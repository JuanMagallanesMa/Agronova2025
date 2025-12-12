// lib/models/insumo_asignado.dart
// (NUEVO ARCHIVO RECOMENDADO)

class InsumoAsignado {
  String idInsumo;
  double cantidad; // Usamos double para cantidades (ej: 1.5 kg, 2.5 L)

  InsumoAsignado({required this.idInsumo, required this.cantidad});

  factory InsumoAsignado.fromMap(Map<String, dynamic> data) {
    return InsumoAsignado(
      idInsumo: data['idInsumo'] as String,
      // Firebase puede guardar 'cantidad' como int o double,
      // así que lo casteamos a num y luego a double.
      cantidad: (data['cantidad'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'idInsumo': idInsumo, 'cantidad': cantidad};
  }

  // Opcional: copyWith si piensas modificarlo inmutablemente
  InsumoAsignado copyWith({String? idInsumo, double? cantidad}) {
    return InsumoAsignado(
      idInsumo: idInsumo ?? this.idInsumo,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}
