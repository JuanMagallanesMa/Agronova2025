// lib/providers/tipo_tarea_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/tipo_tarea.dart';
import 'package:agronova_app/api/tipo_tarea_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class TipoTareaProvider extends ChangeNotifier {
  final TipoTareaApi _api = TipoTareaApi();
  List<TipoTarea> _items = [];
  bool _isLoading = false;

  List<TipoTarea> get items =>
      _items.where((i) => i.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

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

  // CORRECCIÓN: Crea una nueva instancia con el estado forzado.
  Future<void> add(TipoTarea item) async {
    try {
      final itemToSend = TipoTarea(
        id: item.id,
        nombre: item.nombre,
        estado: AppStatus.activo,
      );
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tipo tarea: $e');
    }
  }

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

  // Eliminación Lógica: Crea nueva instancia y la reemplaza.
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
