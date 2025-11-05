import 'referencia_base.dart';

// Modelo para la tabla TipoTarea
class TipoTarea extends ReferenciaBase {
  TipoTarea({ super.id, required super.nombre, super.estado});

  factory TipoTarea.fromMap(Map<String, dynamic> data) {
    return TipoTarea(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }
  factory TipoTarea.fromReferenciaBase(ReferenciaBase ref) {
    return TipoTarea(id: ref.id, nombre: ref.nombre, estado: ref.estado);
  }
}
