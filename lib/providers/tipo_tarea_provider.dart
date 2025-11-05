import 'package:flutter/material.dart';
import '../models/tipo_tarea.dart';
import '../api/tipo_tarea_api.dart';
import '../core/app_constants.dart';
import '../core/provider_interfaces.dart'; // <--- Importación de la interfaz

class TipoTareaProvider extends ChangeNotifier
    implements IReferenciaProvider<TipoTarea> {
  // <--- Implementación de la Interfaz

  final TipoTareaApi _api = TipoTareaApi();
  List<TipoTarea> _items = [];
  bool _isLoading = false;

  @override
  List<TipoTarea> get items =>
      _items.where((i) => i.estado == AppStatus.activo).toList();
  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching tipos tarea: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> add(TipoTarea item) async {
    try {
      final itemToSend = TipoTarea(nombre: item.nombre);
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tipo tarea: $e');
    }
  }

  @override
  Future<void> update(TipoTarea item) async {
    try {
      await _api.update(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating tipo tarea: $e');
    }
  }

  @override
  Future<void> deleteLogico(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _items[index];
        final updatedItem = TipoTarea(
          id: oldItem.id,
          nombre: oldItem.nombre,
          estado: AppStatus.inactivo,
        );
        _items[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting tipo tarea logically: $e');
    }
  }
}
