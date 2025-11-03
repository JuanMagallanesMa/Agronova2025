import 'referencia_base.dart';

// Modelo para la tabla Ubicacion
class Ubicacion extends ReferenciaBase {
  Ubicacion({required super.id, required super.nombre, super.estado});

  factory Ubicacion.fromMap(Map<String, dynamic> data) {
    return Ubicacion(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }
}
