// lib/api/agricultor_api.dart
import 'http_client.dart';
import 'package:agronova_app/models/agricultor.dart';

class AgricultorApi extends HttpClient {
  static const String _endpoint = '/agricultores';

  Future<List<Agricultor>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    return jsonList.map(Agricultor.fromMap).toList();
  }

  Future<Agricultor> add(Agricultor agricultor) async {
    final jsonResponse = await post(_endpoint, agricultor.toMap());
    return Agricultor.fromMap(jsonResponse);
  }

  Future<void> update(Agricultor agricultor) async {
    if (agricultor.id == null) {
      throw Exception('ID de Agricultor requerido para actualizar.');
    }
    await put(_endpoint, agricultor.id!, agricultor.toMap());
  }

  // --- CAMBIO AQUÍ ---
  // Ahora llamamos a 'delete', que el backend interpreta como borrado lógico
  Future<void> deleteLogico(String id) async {
    if (id.isEmpty) {
      throw Exception('ID de Agricultor requerido para borrado lógico.');
    }
    // Llama al nuevo método delete en http_client
    await delete(_endpoint, id);
  }

  // --------------------
}
