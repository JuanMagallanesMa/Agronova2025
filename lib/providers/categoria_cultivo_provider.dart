// lib/providers/categoria_cultivo_provider.dart (CORREGIDO)
import 'package:flutter/material.dart';
import 'package:agronova_app/models/categoria_cultivo.dart';
import 'package:agronova_app/api/categoria_cultivo_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class CategoriaCultivoProvider extends ChangeNotifier {
  final CategoriaCultivoApi _api = CategoriaCultivoApi();
  List<CategoriaCultivo> _items = [];
  bool _isLoading = false;

  List<CategoriaCultivo> get items =>
      _items.where((i) => i.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching categorias: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CORRECCIÓN: Crea una nueva instancia inmutable con el estado forzado.
  Future<void> add(CategoriaCultivo item) async {
    try {
      // 1. Crea una NUEVA instancia forzando el estado a Activo.
      final itemToSend = CategoriaCultivo(
        id: item.id,
        nombre: item.nombre,
        estado: AppStatus.activo, // <--- Estado forzado
      );

      // 2. Envía la nueva instancia a la API.
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding categoria: $e');
    }
  }

  // Actualiza la instancia local (el item que viene ya es la instancia de actualización)
  Future<void> update(CategoriaCultivo item) async {
    try {
      await _api.update(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating categoria: $e');
    }
  }

  // Eliminación Lógica: Llama a la API y reemplaza el objeto local.
  Future<void> deleteLogico(String id) async {
    try {
      // 1. Llama a la API para cambiar el estado en el backend
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _items[index];
        // 2. Crea una NUEVA instancia inmutable con el estado modificado
        final updatedItem = CategoriaCultivo(
          id: oldItem.id,
          nombre: oldItem.nombre,
          estado: AppStatus.inactivo,
        );
        // 3. Reemplaza la instancia antigua en la lista
        _items[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting categoria logically: $e');
    }
  }
}
