//Clase base para simplificar la creación de modelos de catálogos
class ReferenciaBase {
  final String? id;
  final String nombre;
  final String? estado;

  ReferenciaBase({this.id, required this.nombre, this.estado});

  // Convierte Map (JSON de la API) a objeto ReferenciaBase
  factory ReferenciaBase.fromMap(Map<String, dynamic> data) {
    return ReferenciaBase(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }

  // Convierte objeto ReferenciaBase a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      if (estado != null) 'estado': estado,
    };
  }
  Map<String, dynamic> toUpdateMap() {
    return {
      'nombre': nombre,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferenciaBase &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
