import 'http_client.dart';
import 'package:agronova_app/models/cultivo.dart';

class CultivoApi extends HttpClient {
  static const String _endpoint = '/cultivos';

  Future<List<Cultivo>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    return jsonList.map(Cultivo.fromMap).toList();
  }

  Future<Cultivo> add(Cultivo cultivo) async {
    final jsonResponse = await post(_endpoint, cultivo.toMap());
    return Cultivo.fromMap(jsonResponse);
  }

  Future<void> update(Cultivo cultivo) async {
    if (cultivo.id == null) {
      throw Exception('ID de Cultivo requerido para actualizar.');
    }
    await put(_endpoint, cultivo.id!, cultivo.toUpdateMap());
  }

  // Eliminación Lógica
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Cultivo requerido para actualizar el estado.');
    }
    await delete(_endpoint, id);
  }
}
