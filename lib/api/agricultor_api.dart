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

  // Eliminación Lógica
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Agricultor requerido para actualizar el estado.');
    }
    // El backend debe manejar este PUT para solo modificar el campo 'estado'.
    await put(_endpoint, id, {'estado': nuevoEstado});
  }
}
