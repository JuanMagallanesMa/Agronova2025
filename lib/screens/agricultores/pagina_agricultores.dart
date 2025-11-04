import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/agricultor.dart';
import 'package:agronova_app/providers/agricultor_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_agricultor.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_agricultor.dart';

class PaginaAgricultores extends StatefulWidget {
  static const String routeName = '/agricultores';
  const PaginaAgricultores({super.key});

  @override
  State<PaginaAgricultores> createState() => _PaginaAgricultoresState();
}

class _PaginaAgricultoresState extends State<PaginaAgricultores> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AgricultorProvider>(
          context,
          listen: false,
        ).fetchAgricultores();
      }
    });
  }

  void _navigateToRegistro([Agricultor? agricultor]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistroAgricultor(agricultor: agricultor),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Agricultor agricultor) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Agricultor',
        content: '¿Está seguro que desea inactivar a "${agricultor.nombre}"?',
        onConfirm: () {
          Provider.of<AgricultorProvider>(
            context,
            listen: false,
          ).deleteAgricultor(agricultor.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final agricultorProvider = Provider.of<AgricultorProvider>(context);

    return MainScaffold(
      title: 'Gestión de Agricultores',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: agricultorProvider.isLoading
          ? const LoadingSpinner()
          : agricultorProvider.agricultores.isEmpty
          ? const Center(
              child: Text('No hay agricultores activos registrados.'),
            )
          : ListView.builder(
              itemCount: agricultorProvider.agricultores.length,
              itemBuilder: (ctx, i) {
                final agricultor = agricultorProvider.agricultores[i];
                return CardAgricultor(
                  agricultor: agricultor,
                  onEdit: () => _navigateToRegistro(agricultor),
                  onDelete: () => _showDeleteDialog(context, agricultor),
                );
              },
            ),
    );
  }
}
