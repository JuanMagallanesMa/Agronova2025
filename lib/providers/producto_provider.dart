// lib/providers/producto_provider.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/producto.dart';
import 'package:agronova_app/api/producto_api.dart';
import 'package:agronova_app/core/app_constants.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoApi _api = ProductoApi();
  List<Producto> _productos = [];
  bool _isLoading = false;

  List<Producto> get productos =>
      _productos.where((p) => p.estado == AppStatus.activo).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchProductos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _productos = await _api.fetchAll();
    } catch (e) {
      debugPrint('Error fetching productos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CORRECCIÓN: Crea una nueva instancia con el estado forzado.
  Future<void> addProducto(Producto producto) async {
    try {
      final itemToSend = Producto(
        id: producto.id,
        nombre: producto.nombre,
        descripcion: producto.descripcion,
        cantidadStock: producto.cantidadStock,
        precioCaja: producto.precioCaja,
        idCultivo: producto.idCultivo,
        estado: AppStatus.activo, // <--- Estado forzado
      );
      final newProducto = await _api.add(itemToSend);
      _productos.add(newProducto);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding producto: $e');
    }
  }

  Future<void> updateProducto(Producto producto) async {
    try {
      await _api.update(producto);
      final index = _productos.indexWhere((p) => p.id == producto.id);
      if (index != -1) {
        _productos[index] = producto;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating producto: $e');
    }
  }

  // Eliminación Lógica: Crea nueva instancia y la reemplaza.
  Future<void> deleteProducto(String id) async {
    try {
      await _api.updateEstado(id, AppStatus.inactivo);

      final index = _productos.indexWhere((p) => p.id == id);
      if (index != -1) {
        final oldItem = _productos[index];
        final updatedItem = Producto(
          id: oldItem.id,
          nombre: oldItem.nombre,
          descripcion: oldItem.descripcion,
          cantidadStock: oldItem.cantidadStock,
          precioCaja: oldItem.precioCaja,
          idCultivo: oldItem.idCultivo,
          estado: AppStatus.inactivo,
        );
        _productos[index] = updatedItem;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting producto logically: $e');
    }
  }

  List<Producto> searchProducto(String nombre) {
    if (nombre.isEmpty) return productos;
    return productos
        .where((p) => p.nombre.toLowerCase().contains(nombre.toLowerCase()))
        .toList();
  }
}
