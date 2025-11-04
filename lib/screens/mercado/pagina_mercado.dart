import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/venta.dart';
import 'package:agronova_app/providers/venta_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_venta.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_venta.dart';

class PaginaVentas extends StatefulWidget {
  static const String routeName = '/ventas';
  const PaginaVentas({super.key});

  @override
  State<PaginaVentas> createState() => _PaginaVentasState();
}

class _PaginaVentasState extends State<PaginaVentas> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<VentaProvider>(context, listen: false).fetchVentas(),
    );
  }

  void _navigateToRegistro([Venta? venta]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegistroVenta(venta: venta)),
    );
  }

  void _showDeleteDialog(BuildContext context, Venta venta) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Venta',
        content:
            '¿Está seguro que desea inactivar la venta a "${venta.nombreCliente}"?',
        onConfirm: () {
          Provider.of<VentaProvider>(
            context,
            listen: false,
          ).deleteVenta(venta.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ventaProvider = Provider.of<VentaProvider>(context);

    return MainScaffold(
      title: 'Gestión de Ventas',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: ventaProvider.isLoading
          ? const LoadingSpinner()
          : ventaProvider.ventas.isEmpty
          ? const Center(child: Text('No hay ventas registradas.'))
          : ListView.builder(
              itemCount: ventaProvider.ventas.length,
              itemBuilder: (ctx, i) {
                final venta = ventaProvider.ventas[i];
                return CardVenta(
                  venta: venta,
                  // Asumiendo que CardVenta tiene onEdit y onDelete
                  // Si no los tiene, deberás agregarlos a card_venta.dart
                  onEdit: () => _navigateToRegistro(venta),
                  onDelete: () => _showDeleteDialog(context, venta),
                );
              },
            ),
    );
  }
}
