class Insumo {
  String? id;
  String idTipoInsumo; // Foreign Key: TipoInsumo
  String descripcion;
  int cantidad;
  String unidadMedida;
  String? estado;

  Insumo({
    this.id,
    required this.idTipoInsumo,
    required this.descripcion,
    required this.cantidad,
    required this.unidadMedida,
    this.estado,
  });

  // Convierte Map (JSON de la API) a objeto Insumo
  factory Insumo.fromMap(Map<String, dynamic> data) {
    return Insumo(
      id: data['id'] as String?,
      idTipoInsumo: data['idTipoInsumo'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      cantidad: (data['cantidad'] as num?)?.toInt() ?? 0,
      unidadMedida: data['unidadMedida'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }

  // Convierte objeto Insumo a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'idTipoInsumo': idTipoInsumo,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'unidadMedida': unidadMedida,
      if (estado != null) 'estado': estado,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'idTipoInsumo': idTipoInsumo,
      'descripcion': descripcion,
      'cantidad': cantidad,
      'unidadMedida': unidadMedida,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Insumo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
