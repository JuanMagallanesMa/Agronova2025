import 'package:flutter/material.dart';
import '../models/categoria_cultivo.dart';
import '../api/categoria_cultivo_api.dart';
import '../core/app_constants.dart';
import '../core/provider_interfaces.dart'; // <--- Importación de la interfaz

class CategoriaCultivoProvider extends ChangeNotifier
    implements IReferenciaProvider<CategoriaCultivo> {
  // <--- Implementación de la Interfaz

  final CategoriaCultivoApi _api = CategoriaCultivoApi();
  List<CategoriaCultivo> _items = [];
  bool _isLoading = false;

  @override
  List<CategoriaCultivo> get items =>
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
      debugPrint('Error fetching categorias: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> add(CategoriaCultivo item) async {
    try {
      final itemToSend = CategoriaCultivo(
        nombre: item.nombre,
      );
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding categoria: $e');
    }
  }

  @override
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

  @override
  Future<void> deleteLogico(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _items[index];
        final updatedItem = CategoriaCultivo(
          id: oldItem.id,
          nombre: oldItem.nombre,
          estado: AppStatus.inactivo,
        );
        _items[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting categoria logically: $e');
    }
  }
}
