// lib/providers/venta_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/venta.dart';
import 'package:agronova_app/api/venta_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class VentaProvider extends ChangeNotifier {
  final VentaApi _api = VentaApi();
  List<Venta> _ventas = [];
  bool _isLoading = false;

  List<Venta> get ventas =>
      _ventas.where((v) => v.estado != AppStatus.anulada).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchVentas() async {
    _isLoading = true;
    notifyListeners();
    try {
      _ventas = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching ventas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CORRECCIÓN: Crea una nueva instancia con el estado forzado.
  Future<void> addVenta(Venta venta) async {
    try {
      final itemToSend = Venta(
        id: venta.id,
        nombreCliente: venta.nombreCliente,
        cedula: venta.cedula,
        total: venta.total,
        detalles: venta.detalles,
        estado: AppStatus.completada, 
        fecha: DateTime.now(), 
      );
      final newVenta = await _api.add(itemToSend);
      _ventas.add(newVenta);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding venta: $e');
    }
  }

  // Anulación Lógica: Crea nueva instancia y la reemplaza.
  Future<void> anularVenta(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.anulada);

      final index = _ventas.indexWhere((v) => v.id == id);
      if (index != -1) {
        final oldItem = _ventas[index];
        final updatedItem = Venta(
          id: oldItem.id,
          nombreCliente: oldItem.nombreCliente,
          cedula: oldItem.cedula,
          total: oldItem.total,
          detalles: oldItem.detalles,
          estado: AppStatus.anulada, fecha: DateTime.now(),
        );
        _ventas[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error anulando venta: $e');
    }
  }

  List<Venta> searchVentas(String query) {
    if (query.isEmpty) return ventas;
    return ventas.where((v) => v.cedula.contains(query)).toList();
  }
}
