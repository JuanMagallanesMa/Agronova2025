// lib/providers/tarea_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/api/tarea_api.dart';
import 'package:agronova_app/core/app_constants.dart';

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

  // CORRECCIÓN: Crea una nueva instancia con el estado forzado.
  Future<void> addTarea(Tarea tarea) async {
    try {
      final itemToSend = Tarea(
        id: tarea.id,
        idTipoTarea: tarea.idTipoTarea,
        nombre: tarea.nombre,
        descripcion: tarea.descripcion,
        idCultivo: tarea.idCultivo,
        fechaInicio: tarea.fechaInicio,
        fechaFin: tarea.fechaFin,
        idAgricultores: tarea.idAgricultores,
        idInsumos: tarea.idInsumos,
        estado: AppStatus.pendiente, // <--- Estado forzado
      );
      final newTarea = await _api.add(itemToSend);
      _tareas.add(newTarea);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tarea: $e');
    }
  }

  Future<void> updateTarea(Tarea tarea) async {
    try {
      await _api.update(tarea);
      final index = _tareas.indexWhere((t) => t.id == tarea.id);
      if (index != -1) {
        _tareas[index] = tarea;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating tarea: $e');
    }
  }

  // Tarea completada: Crea nueva instancia y la reemplaza.
  Future<void> completarTarea(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.completada);

      final index = _tareas.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldItem = _tareas[index];
        final updatedItem = Tarea(
          id: oldItem.id,
          idTipoTarea: oldItem.idTipoTarea,
          nombre: oldItem.nombre,
          descripcion: oldItem.descripcion,
          idCultivo: oldItem.idCultivo,
          fechaInicio: oldItem.fechaInicio,
          fechaFin: oldItem.fechaFin,
          idAgricultores: oldItem.idAgricultores,
          idInsumos: oldItem.idInsumos,
          estado: AppStatus.completada,
        );
        _tareas[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error completing tarea: $e');
    }
  }

  // Eliminación Lógica: Crea nueva instancia y la reemplaza.
  Future<void> deleteTarea(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _tareas.indexWhere((t) => t.id == id);
      if (index != -1) {
        final oldItem = _tareas[index];
        final updatedItem = Tarea(
          id: oldItem.id,
          idTipoTarea: oldItem.idTipoTarea,
          nombre: oldItem.nombre,
          descripcion: oldItem.descripcion,
          idCultivo: oldItem.idCultivo,
          fechaInicio: oldItem.fechaInicio,
          fechaFin: oldItem.fechaFin,
          idAgricultores: oldItem.idAgricultores,
          idInsumos: oldItem.idInsumos,
          estado: AppStatus.inactivo,
        );
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
