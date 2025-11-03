// lib/providers/cultivo_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/api/cultivo_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class CultivoProvider extends ChangeNotifier {
  final CultivoApi _cultivoApi = CultivoApi();
  late final CategoriaCultivoProvider categoriaProvider;
  late final UbicacionProvider ubicacionProvider;

  List<Cultivo> _cultivos = [];
  bool _isLoading = false;

  List<Cultivo> get cultivos =>
      _cultivos.where((c) => c.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

  void initialize(BuildContext context) {
    // Aquí se obtendrían las referencias a otros providers (ej. categorías, ubicaciones)
  }

  Future<void> fetchCultivos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cultivos = await _cultivoApi.fetchAll();
    } catch (e) {
      debugPrint('Error fetching cultivos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CORRECCIÓN: Crea una nueva instancia con el estado forzado.
  Future<void> addCultivo(Cultivo cultivo) async {
    try {
      final itemToSend = Cultivo(
        id: cultivo.id,
        nombre: cultivo.nombre,
        idCategoria: cultivo.idCategoria,
        idUbicacion: cultivo.idUbicacion,
        fechaInicio: cultivo.fechaInicio,
        estado: AppStatus.activo, // <--- Estado forzado
      );
      final newCultivo = await _cultivoApi.add(itemToSend);
      _cultivos.add(newCultivo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding cultivo: $e');
    }
  }

  Future<void> updateCultivo(Cultivo cultivo) async {
    try {
      await _cultivoApi.update(cultivo);
      final index = _cultivos.indexWhere((c) => c.id == cultivo.id);
      if (index != -1) {
        _cultivos[index] = cultivo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating cultivo: $e');
    }
  }

  // Eliminación Lógica: Crea nueva instancia y la reemplaza.
  Future<void> deleteCultivo(String id) async {
    try {
      await _cultivoApi.updateEstado(id, AppStatus.inactivo);

      final index = _cultivos.indexWhere((c) => c.id == id);
      if (index != -1) {
        final oldItem = _cultivos[index];
        final updatedItem = Cultivo(
          id: oldItem.id,
          nombre: oldItem.nombre,
          idCategoria: oldItem.idCategoria,
          idUbicacion: oldItem.idUbicacion,
          fechaInicio: oldItem.fechaInicio,
          estado: AppStatus.inactivo,
        );
        _cultivos[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting cultivo logically: $e');
    }
  }

  List<Cultivo> searchCultivo(String nombre, String categoriaId) {
    return cultivos.where((c) {
      final matchName =
          nombre.isEmpty ||
          c.nombre.toLowerCase().contains(nombre.toLowerCase());
      final matchCategory = categoriaId.isEmpty || c.idCategoria == categoriaId;
      return matchName && matchCategory;
    }).toList();
  }
}
