import 'http_client.dart';
import 'package:agronova_app/models/producto.dart';

class ProductoApi extends HttpClient {
  static const String _endpoint = '/productos';

  Future<List<Producto>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    return jsonList.map(Producto.fromMap).toList();
  }

  Future<Producto> add(Producto producto) async {
    final jsonResponse = await post(_endpoint, producto.toMap());
    return Producto.fromMap(jsonResponse);
  }

  Future<void> update(Producto producto) async {
    if (producto.id == null) {
      throw Exception('ID de Producto requerido para actualizar.');
    }
    await put(_endpoint, producto.id!, producto.toMap());
  }

  // Eliminación Lógica
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Producto requerido para actualizar el estado.');
    }
    await put(_endpoint, id, {'estado': nuevoEstado});
  }
}
