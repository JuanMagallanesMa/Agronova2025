// lib/providers/insumo_provider.dart
import 'package:flutter/material.dart';
import '../models/insumo.dart'; // Ruta relativa
import '../api/insumo_api.dart'; // Ruta relativa
import '../core/app_constants.dart'; // Ruta relativa
import '../providers/tipo_insumo_provider.dart'; // Ruta relativa (necesaria para la inyección de la dependencia de catálogo)

class InsumoProvider extends ChangeNotifier {
  final InsumoApi _api = InsumoApi();

  // Lista local para gestión de estado
  List<Insumo> _insumos = [];
  bool _isLoading = false;

  // Solo devuelve insumos activos
  List<Insumo> get insumos =>
      _insumos.where((i) => i.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchInsumos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _insumos = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching insumos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Implementa Inmutabilidad: Crea nueva instancia con estado 'Activo' antes de enviar.
  Future<void> addInsumo(Insumo insumo) async {
    try {
      final itemToSend = Insumo(
        id: insumo.id,
        idTipoInsumo: insumo.idTipoInsumo,
        descripcion: insumo.descripcion,
        cantidad: insumo.cantidad,
        unidadMedida: insumo.unidadMedida,
        estado: AppStatus.activo, // Forzado a activo
      );
      final newInsumo = await _api.add(itemToSend);
      _insumos.add(newInsumo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding insumo: $e');
    }
  }

  Future<void> updateInsumo(Insumo insumo) async {
    try {
      await _api.update(insumo);
      final index = _insumos.indexWhere((i) => i.id == insumo.id);
      if (index != -1) {
        _insumos[index] = insumo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating insumo: $e');
    }
  }

  // Eliminación Lógica: Llama a la API, crea nueva instancia y la reemplaza en la lista.
  Future<void> deleteInsumo(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _insumos.indexWhere((i) => i.id == id);
      if (index != -1) {
        final oldItem = _insumos[index];
        final updatedItem = Insumo(
          id: oldItem.id,
          idTipoInsumo: oldItem.idTipoInsumo,
          descripcion: oldItem.descripcion,
          cantidad: oldItem.cantidad,
          unidadMedida: oldItem.unidadMedida,
          estado: AppStatus.inactivo, // Nuevo estado
        );
        _insumos[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting insumo logically: $e');
    }
  }

  List<Insumo> searchInsumo(String descripcion, String tipoId) {
    return insumos.where((i) {
      final matchDesc =
          descripcion.isEmpty ||
          i.descripcion.toLowerCase().contains(descripcion.toLowerCase());
      final matchTipo = tipoId.isEmpty || i.idTipoInsumo == tipoId;
      return matchDesc && matchTipo;
    }).toList();
  }
}
