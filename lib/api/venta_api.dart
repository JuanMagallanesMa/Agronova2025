import 'http_client.dart';
import 'package:agronova_app/models/venta.dart';

class VentaApi extends HttpClient {
  static const String _endpoint = '/ventas';

  Future<List<Venta>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    // La API debe retornar la Venta con el detalle anidado.
    return jsonList.map(Venta.fromMap).toList();
  }

  Future<Venta> add(Venta venta) async {
    // El toMap de Venta incluye la lista de VentaDetalle anidada (toMap())
    final jsonResponse = await post(_endpoint, venta.toMap());
    // El fromMap de Venta debe ser capaz de deserializar el detalle anidado
    return Venta.fromMap(jsonResponse);
  }

  // Anulación/Inactivación Lógica (para anular una venta)
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Venta requerido para actualizar el estado.');
    }
    await delete(_endpoint, id);
  }
}
