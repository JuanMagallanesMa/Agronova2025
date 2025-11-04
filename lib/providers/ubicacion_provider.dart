import 'package:flutter/material.dart';
import '../models/ubicacion.dart';
import '../api/ubicacion_api.dart';
import '../core/app_constants.dart';
import '../core/provider_interfaces.dart'; // <--- Importación de la interfaz

class UbicacionProvider extends ChangeNotifier
    implements IReferenciaProvider<Ubicacion> {
  // <--- Implementación de la Interfaz

  final UbicacionApi _api = UbicacionApi();
  List<Ubicacion> _items = [];
  bool _isLoading = false;

  @override
  List<Ubicacion> get items =>
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
      debugPrint('Error fetching ubicaciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> add(Ubicacion item) async {
    try {
      final itemToSend = Ubicacion(
        id: item.id,
        nombre: item.nombre,
        estado: AppStatus.activo,
      );
      final newItem = await _api.add(itemToSend);
      _items.add(newItem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding ubicacion: $e');
    }
  }

  @override
  Future<void> update(Ubicacion item) async {
    try {
      await _api.update(item);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating ubicacion: $e');
    }
  }

  @override
  Future<void> deleteLogico(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _items.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _items[index];
        final updatedItem = Ubicacion(
          id: oldItem.id,
          nombre: oldItem.nombre,
          estado: AppStatus.inactivo,
        );
        _items[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting ubicacion logically: $e');
    }
  }
}
