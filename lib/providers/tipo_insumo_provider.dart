import 'package:flutter/material.dart';
import '../models/tipo_insumo.dart';
import '../api/tipo_insumo_api.dart';
import '../core/app_constants.dart';
import '../core/provider_interfaces.dart'; // <--- Importación de la interfaz

class TipoInsumoProvider extends ChangeNotifier
    implements IReferenciaProvider<TipoInsumo> {
  // <--- Implementación de la Interfaz

  final TipoInsumoApi _api = TipoInsumoApi();
  List<TipoInsumo> _items = [];
  bool _isLoading = false;

  @override
  List<TipoInsumo> get items =>
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
      debugPrint('Error fetching tipos insumo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> add(TipoInsumo item) async {
    try {
      final itemToSend = TipoInsumo(
        id: item.id,
        nombre: item.nombre,
        estado: AppStatus.activo,
      );
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tipo insumo: $e');
    }
  }

  @override
  Future<void> update(TipoInsumo item) async {
    try {
      await _api.update(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating tipo insumo: $e');
    }
  }

  @override
  Future<void> deleteLogico(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _items[index];
        final updatedItem = TipoInsumo(
          id: oldItem.id,
          nombre: oldItem.nombre,
          estado: AppStatus.inactivo,
        );
        _items[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting tipo insumo logically: $e');
    }
  }
}
