import 'http_client.dart';
import 'package:agronova_app/models/tarea.dart';

class TareaApi extends HttpClient {
  static const String _endpoint = '/tareas';

  Future<List<Tarea>> fetchAll() async {
    final jsonList = await fetchList(_endpoint);
    // La API debe retornar la Tarea con las listas de IDs (idAgricultores, idInsumos)
    return jsonList.map(Tarea.fromMap).toList();
  }

  Future<Tarea> add(Tarea tarea) async {
    final jsonResponse = await post(_endpoint, tarea.toMap());
    return Tarea.fromMap(jsonResponse);
  }

  Future<void> update(Tarea tarea) async {
    if (tarea.id == null) {
      throw Exception('ID de Tarea requerido para actualizar.');
    }
    await put(_endpoint, tarea.id!, tarea.toMap());
  }

  Future<void> updateComplete(Tarea tarea) async {
    if (tarea.id == null) {
      throw Exception('ID de Tarea requerido para actualizar.');
    }
    await put(_endpoint, tarea.id!, tarea.toUpdateCompleteMap());
  }

  // Eliminación Lógica
  Future<void> updateEstado(String id, String nuevoEstado) async {
    if (id.isEmpty) {
      throw Exception('ID de Tarea requerido para actualizar el estado.');
    }
    await delete(_endpoint, id);
  }
}
