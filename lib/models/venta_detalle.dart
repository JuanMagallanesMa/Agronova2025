class VentaDetalle {
  final String idProducto;
  final String nombreProducto;
  final double precioCaja; // Este es el precio unitario
  final int cantidad;

  VentaDetalle({
    required this.idProducto,
    required this.nombreProducto,
    required this.precioCaja,
    required this.cantidad,
  });

  // Convierte Map (JSON) a objeto VentaDetalle
  factory VentaDetalle.fromMap(Map<String, dynamic> data) {
    return VentaDetalle(
      idProducto: data['idProducto'] as String? ?? '',
      nombreProducto: data['nombreProducto'] as String? ?? '',
      precioCaja: (data['precioCaja'] as num?)?.toDouble() ?? 0.0,
      cantidad: (data['cantidad'] as num?)?.toInt() ?? 0,
    );
  }

  // Convierte objeto VentaDetalle a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombreProducto': nombreProducto,
      'precioCaja': precioCaja,
      'cantidad': cantidad,
    };
  }

  // --- CORRECCIÓN ---
  // Se añade copyWith para actualizar la cantidad en el formulario de registro
  VentaDetalle copyWith({
    String? idProducto,
    String? nombreProducto,
    double? precioCaja,
    int? cantidad,
  }) {
    return VentaDetalle(
      idProducto: idProducto ?? this.idProducto,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precioCaja: precioCaja ?? this.precioCaja,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}
