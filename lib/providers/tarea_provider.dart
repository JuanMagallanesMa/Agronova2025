// lib/providers/tarea_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/api/tarea_api.dart';
import 'package:agronova_app/core/app_constants.dart';
// 1. Asegúrate de que Tarea importe InsumoAsignado, este import puede ser necesario
// si Tarea no lo exporta, aunque usualmente no lo es.
// import 'package:agronova_app/models/insumo_asignado.dart';

class TareaProvider extends ChangeNotifier {
  final TareaApi _api = TareaApi();
  List<Tarea> _tareas = [];
  bool _isLoading = false;

  List<Tarea> get tareas =>
      _tareas.where((t) => t.estado != AppStatus.inactivo).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchTareas() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tareas = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching tareas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CORRECCIÓN: Usar copyWith para forzar el estado.
  Future<void> addTarea(Tarea tarea) async {
    try {
      // 2. Usamos copyWith. Esto toma la 'tarea' que viene del formulario
      // (que ya tiene 'insumosAsignados') y solo sobrescribe el estado.
      final itemToSend = tarea.copyWith(estado: AppStatus.pendiente);
      
      final newTarea = await _api.add(itemToSend);
      _tareas.add(newTarea);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tarea: $e');
      // Relanzar el error es buena práctica para que el UI lo atrape
      throw Exception('Error al añadir tarea: $e'); 
    }
  }

  Future<void> updateTarea(Tarea tarea) async {
    try {
      // 3. La tarea que llega aquí ya debe tener los 'insumosAsignados' actualizados
      await _api.updateComplete(tarea);
      final index = _tareas.indexWhere((t) => t.id == tarea.id);
      if (index != -1) {
        _tareas[index] = tarea; // Reemplazamos el objeto completo
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating tarea: $e');
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  // Tarea completada: Refactorizado con copyWith
  Future<void> completarTarea(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.completada);

      final index = _tareas.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldItem = _tareas[index];
        // 4. REFACTOR: Mucho más limpio y mantenible que reconstruir
        // el objeto campo por campo.
        final updatedItem = oldItem.copyWith(estado: AppStatus.completada);
        _tareas[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing tarea: $e');
    }
  }

  // Eliminación Lógica: Refactorizado con copyWith
  Future<void> deleteTarea(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _tareas.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldItem = _tareas[index];
        // 5. REFACTOR: Igual que en completarTarea, usamos copyWith.
        final updatedItem = oldItem.copyWith(estado: AppStatus.inactivo);
        _tareas[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting tarea logically: $e');
    }
  }

  List<Tarea> searchTarea(String nombre, String estado) {
    return tareas.where((t) {
      final matchName =
          nombre.isEmpty ||
          t.nombre.toLowerCase().contains(nombre.toLowerCase());
      final matchStatus = estado.isEmpty || t.estado == estado;
      return matchName && matchStatus;
    }).toList();
  }
}