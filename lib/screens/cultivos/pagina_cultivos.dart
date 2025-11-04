import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_cultivo.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_cultivo.dart';

class PaginaCultivos extends StatefulWidget {
  static const String routeName = '/cultivos';
  const PaginaCultivos({super.key});

  @override
  State<PaginaCultivos> createState() => _PaginaCultivosState();
}

class _PaginaCultivosState extends State<PaginaCultivos> {
  @override
  void initState() {
    super.initState();
    // Carga inicial del CultivoProvider (asume que los Providers de catálogo ya se están cargando en main.dart)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CultivoProvider>(context, listen: false).fetchCultivos();
      }
    });
    // Se recomienda cargar los catálogos aquí si no estás seguro de que main.dart lo haga:
    // Future.microtask(() => Provider.of<CategoriaCultivoProvider>(context, listen: false).fetchAll());
    // Future.microtask(() => Provider.of<UbicacionProvider>(context, listen: false).fetchAll());
  }

  void _navigateToRegistro([Cultivo? cultivo]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistroCultivo(cultivo: cultivo),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Cultivo cultivo) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Cultivo',
        content:
            '¿Está seguro que desea inactivar el cultivo "${cultivo.nombre}"? Esto afectará a Productos y Tareas relacionados.',
        onConfirm: () {
          Provider.of<CultivoProvider>(
            context,
            listen: false,
          ).deleteCultivo(cultivo.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cultivoProvider = Provider.of<CultivoProvider>(context);
    final categoriaProvider = Provider.of<CategoriaCultivoProvider>(context);
    final ubicacionProvider = Provider.of<UbicacionProvider>(context);

    final bool isDataLoading =
        cultivoProvider.isLoading ||
        categoriaProvider.isLoading ||
        ubicacionProvider.isLoading;

    return MainScaffold(
      title: 'Gestión de Cultivos',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: isDataLoading
          ? const LoadingSpinner()
          : cultivoProvider.cultivos.isEmpty
          ? const Center(child: Text('No hay cultivos activos registrados.'))
          : ListView.builder(
              itemCount: cultivoProvider.cultivos.length,
              itemBuilder: (ctx, i) {
                final cultivo = cultivoProvider.cultivos[i];
                return CardCultivo(
                  cultivo: cultivo,
                  onEdit: () => _navigateToRegistro(cultivo),
                  onDelete: () => _showDeleteDialog(context, cultivo),
                );
              },
            ),
    );
  }
}
