// lib/providers/agricultor_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/agricultor.dart';
import 'package:agronova_app/api/agricultor_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class AgricultorProvider extends ChangeNotifier {
  final AgricultorApi _api = AgricultorApi();
  List<Agricultor> _agricultores = [];
  bool _isLoading = false;

  List<Agricultor> get agricultores =>
      _agricultores.where((a) => a.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchAgricultores() async {
    _isLoading = true;
    notifyListeners();
    try {
      _agricultores = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching agricultores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAgricultor(Agricultor agricultor) async {
    try {
      final itemToSend = Agricultor(
        id: agricultor.id,
        nombre: agricultor.nombre,
        edad: agricultor.edad,
        zona: agricultor.zona,
        experiencia: agricultor.experiencia,
        estado: AppStatus.activo,
      );
      final newAgricultor = await _api.add(itemToSend);
      _agricultores.add(newAgricultor);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding agricultor: $e');
    }
  }

  Future<void> updateAgricultor(Agricultor agricultor) async {
    try {
      await _api.update(agricultor);
      final index = _agricultores.indexWhere((a) => a.id == agricultor.id);
      if (index != -1) {
        _agricultores[index] = agricultor;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating agricultor: $e');
    }
  }

  // --- CAMBIO AQUÍ ---
  Future<void> deleteAgricultor(String id) async {
    try {
      // Llama al nuevo método de la API que envía un DELETE
      await _api.deleteLogico(id);

      final index = _agricultores.indexWhere((a) => a.id == id);
      if (index != -1) {
        final oldItem = _agricultores[index];
        // Actualiza el estado localmente para que desaparezca de la UI
        final updatedItem = Agricultor(
          id: oldItem.id,
          nombre: oldItem.nombre,
          edad: oldItem.edad,
          zona: oldItem.zona,
          experiencia: oldItem.experiencia,
          estado: AppStatus.inactivo, // <-- Sigue siendo borrado lógico
        );
        _agricultores[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting agricultor logically: $e');
    }
  }
  // --------------------

  List<Agricultor> searchAgricultores(String query) {
    if (query.isEmpty) return agricultores;
    return agricultores
        .where((a) => a.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
