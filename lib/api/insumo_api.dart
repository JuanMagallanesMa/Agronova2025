import 'http_client.dart';
import 'package:agronova_app/models/insumo.dart';

class InsumoApi extends HttpClient {
  static const String _endpoint = '/insumos';

  Future<List<Insumo>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    return jsonList.map(Insumo.fromMap).toList();
  }

  Future<Insumo> add(Insumo insumo) async {
    final jsonResponse = await post(_endpoint, insumo.toMap());
    return Insumo.fromMap(jsonResponse);
  }

  Future<void> update(Insumo insumo) async {
    if (insumo.id == null) {
      throw Exception('ID de Insumo requerido para actualizar.');
    }
    await put(_endpoint, insumo.id!, insumo.toMap());
  }

  // Eliminación Lógica
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Insumo requerido para actualizar el estado.');
    }
    await put(_endpoint, id, {'estado': nuevoEstado});
  }
}
