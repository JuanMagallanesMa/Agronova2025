import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/producto.dart';
import 'package:agronova_app/providers/producto_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_producto.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_producto.dart';

class PaginaProductos extends StatefulWidget {
  static const String routeName = '/productos';
  const PaginaProductos({super.key});

  @override
  State<PaginaProductos> createState() => _PaginaProductosState();
}

class _PaginaProductosState extends State<PaginaProductos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ProductoProvider>(context, listen: false).fetchProductos();
      }
    });
  }

  void _navigateToRegistro([Producto? producto]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistroProducto(producto: producto),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Producto',
        content:
            '¿Está seguro que desea inactivar el producto "${producto.nombre}"?',
        onConfirm: () {
          Provider.of<ProductoProvider>(
            context,
            listen: false,
          ).deleteProducto(producto.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productoProvider = Provider.of<ProductoProvider>(context);

    return MainScaffold(
      title: 'Gestión de Productos',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: productoProvider.isLoading
          ? const LoadingSpinner()
          : productoProvider.productos.isEmpty
          ? const Center(child: Text('No hay productos registrados.'))
          : ListView.builder(
              itemCount: productoProvider.productos.length,
              itemBuilder: (ctx, i) {
                final producto = productoProvider.productos[i];
                return CardProducto(
                  producto: producto,
                  onEdit: () => _navigateToRegistro(producto),
                  onDelete: () => _showDeleteDialog(context, producto),
                );
              },
            ),
    );
  }
}
