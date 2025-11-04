import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/insumo.dart';
import 'package:agronova_app/providers/insumo_provider.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_insumo.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_insumo.dart';

class PaginaInventario extends StatefulWidget {
  static const String routeName = '/inventario';
  const PaginaInventario({super.key});

  @override
  State<PaginaInventario> createState() => _PaginaInventarioState();
}

class _PaginaInventarioState extends State<PaginaInventario> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<InsumoProvider>(context, listen: false).fetchInsumos(),
    );
    // Carga los catálogos si no están cargados
    Future.microtask(
      () => Provider.of<TipoInsumoProvider>(context, listen: false).fetchAll(),
    );
  }

  void _navigateToRegistro([Insumo? insumo]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegistroInsumo(insumo: insumo)),
    );
  }

  void _showDeleteDialog(BuildContext context, Insumo insumo) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Insumo',
        content:
            '¿Está seguro que desea inactivar el insumo "${insumo.descripcion}"? Se mantendrá en el historial de tareas, pero no estará disponible para nuevos registros de insumos.',
        onConfirm: () {
          Provider.of<InsumoProvider>(
            context,
            listen: false,
          ).deleteInsumo(insumo.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insumoProvider = Provider.of<InsumoProvider>(context);
    final tipoInsumoProvider = Provider.of<TipoInsumoProvider>(context);

    final bool isDataLoading =
        insumoProvider.isLoading || tipoInsumoProvider.isLoading;

    return MainScaffold(
      title: 'Gestión de Inventario (Insumos)',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: isDataLoading
          ? const LoadingSpinner()
          : insumoProvider.insumos.isEmpty
          ? const Center(child: Text('No hay insumos activos registrados.'))
          : ListView.builder(
              itemCount: insumoProvider.insumos.length,
              itemBuilder: (ctx, i) {
                final insumo = insumoProvider.insumos[i];
                return CardInsumo(
                  insumo: insumo,
                  onEdit: () => _navigateToRegistro(insumo),
                  onDelete: () => _showDeleteDialog(context, insumo),
                );
              },
            ),
    );
  }
}
