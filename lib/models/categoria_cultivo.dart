import 'referencia_base.dart';

// Modelo para la tabla CategoriaCultivo
class CategoriaCultivo extends ReferenciaBase {
  CategoriaCultivo({required super.id, required super.nombre, super.estado});

  factory CategoriaCultivo.fromMap(Map<String, dynamic> data) {
    return CategoriaCultivo(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }
}
