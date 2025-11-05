import 'referencia_base.dart';

// Modelo para la tabla TipoInsumo
class TipoInsumo extends ReferenciaBase {
  TipoInsumo({super.id, required super.nombre, super.estado});

  factory TipoInsumo.fromMap(Map<String, dynamic> data) {
    return TipoInsumo(
      id: data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }
  factory TipoInsumo.fromReferenciaBase(ReferenciaBase ref) {
    return TipoInsumo(id: ref.id, nombre: ref.nombre, estado: ref.estado);
  }
}
