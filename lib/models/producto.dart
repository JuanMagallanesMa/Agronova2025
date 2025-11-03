class Producto {
  String? id;
  String nombre;
  String descripcion;
  int cantidadStock; // Stock disponible para la venta
  double precioCaja;
  String? estado;
  String idCultivo; // Foreign Key: Origen del cultivo

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.cantidadStock,
    required this.precioCaja,
    required this.idCultivo,
    this.estado,
  }) : assert(precioCaja >= 0, 'El precio no puede ser negativo');

  // Convierte Map (JSON de la API) a objeto Producto
  factory Producto.fromMap(Map<String, dynamic> data) {
    return Producto(
      id: data['id'] as String?,
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      cantidadStock: (data['cantidadStock'] as num?)?.toInt() ?? 0,
      precioCaja: (data['precioCaja'] as num?)?.toDouble() ?? 0.0,
      idCultivo: data['idCultivo'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }

  // Convierte objeto Producto a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'cantidadStock': cantidadStock,
      'precioCaja': precioCaja,
      'idCultivo': idCultivo,
      if (estado != null) 'estado': estado,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Producto && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
