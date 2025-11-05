// lib/api/referencia_api.dart
import 'http_client.dart';
import 'package:agronova_app/models/referencia_base.dart';

typedef ReferenciaFromMap = ReferenciaBase Function(Map<String, dynamic>);

class ReferenciaApi<T extends ReferenciaBase> extends HttpClient {
  final String endpoint;
  final ReferenciaFromMap fromMap;

  ReferenciaApi({required this.endpoint, required this.fromMap});

  // GET: Obtener todas las referencias (llama a fetchList de HttpClient)
  Future<List<T>> fetchAll() async {
    final jsonList = await fetchList(endpoint);
    return jsonList.map((json) => fromMap(json) as T).toList();
  }

  // POST: Crear una nueva referencia (llama a post de HttpClient)
  Future<T> add(T referencia) async {
    final jsonResponse = await post(endpoint, referencia.toMap());
    return fromMap(jsonResponse) as T;
  }

  // PUT: Actualizar una referencia completa (NO es override, solo usa put de la base)
  Future<void> update(T referencia) async {
  if (referencia.id == null || referencia.id!.isEmpty) {
    throw Exception(
      'El ID de la referencia no puede estar vacío para actualizar.',
    );
  }
  // Usa toUpdateMap() en lugar de toMap() para excluir id y estado
  await put(endpoint, referencia.id!, referencia.toUpdateMap());
}

  // FUNCIÓN PARA ELIMINACIÓN LÓGICA
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception(
        'El ID de la referencia no puede estar vacío para actualizar el estado.',
      );
    }

    // El backend debe estar configurado para aceptar este PATCH/PUT lógico.
    await delete(endpoint, id);
  }
}
