import 'referencia_base.dart';

// Modelo para la tabla CategoriaCultivo
class CategoriaCultivo extends ReferenciaBase {
  CategoriaCultivo({super.id, required super.nombre, super.estado});

  factory CategoriaCultivo.fromMap(Map<String, dynamic> data) {
    return CategoriaCultivo(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }
  factory CategoriaCultivo.fromReferenciaBase(ReferenciaBase ref) {
    return CategoriaCultivo(id: ref.id, nombre: ref.nombre, estado: ref.estado);
  }
}
