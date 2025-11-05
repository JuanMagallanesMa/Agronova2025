class Cultivo {
  String? id;
  String nombre;
  String idCategoria; // Foreign Key: CategoriaCultivo
  String idUbicacion; // Foreign Key: Ubicacion
  String? estado;

  Cultivo({
    this.id,
    required this.nombre,
    required this.idCategoria,
    required this.idUbicacion,
    this.estado,
  });

  // Convierte Map (JSON de la API) a objeto Cultivo
  factory Cultivo.fromMap(Map<String, dynamic> data) {
    return Cultivo(
      id: data['id'] as String?,
      nombre: data['nombre'] as String? ?? '',
      idCategoria: data['idCategoria'] as String? ?? '',
      idUbicacion: data['idUbicacion'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }

  // Convierte objeto Cultivo a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'idCategoria': idCategoria,
      'idUbicacion': idUbicacion,
      if (estado != null) 'estado': estado,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'nombre': nombre,
      'idCategoria': idCategoria,
      'idUbicacion': idUbicacion,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cultivo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
