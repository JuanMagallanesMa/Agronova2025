import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/venta.dart';
import 'package:agronova_app/providers/venta_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_venta.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'registro_venta.dart';

// CORRECCIÓN: El nombre de la clase debe coincidir con el archivo
class PaginaMercado extends StatefulWidget {
  static const String routeName = '/ventas';
  const PaginaMercado({super.key});

  @override
  State<PaginaMercado> createState() => _PaginaMercadoState();
}

class _PaginaMercadoState extends State<PaginaMercado> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<VentaProvider>(context, listen: false).fetchVentas();
      }
    });
  }

  void _navigateToRegistro([Venta? venta]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegistroVenta(venta: venta)),
    );
  }

  // --- CORRECCIÓN: Cambiar lógica de "Delete" a "Anular" ---
  void _showAnularDialog(BuildContext context, Venta venta) {
    showDialog(
      context: context,
      // Usamos un AlertDialog estándar en lugar de DeleteDialog para personalizar el texto
      builder: (ctx) => AlertDialog(
        title: const Text('Anular Venta'),
        content: Text(
          '¿Está seguro que desea ANULAR la venta a "${venta.nombreCliente}"? Esta acción no se puede deshacer.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Anular'),
            onPressed: () {
              Provider.of<VentaProvider>(
                context,
                listen: false,
              ).anularVenta(venta.id!); // <-- Llamar a anularVenta
              Navigator.of(ctx).pop();
            },
          ),
        ],
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

                  // --- CORRECCIÓN: Pasar los parámetros correctos ---
                  onAnular: () => _showAnularDialog(context, venta),
                );
              },
            ),
    );
  }
}
