// En: screens/tareas/widgets/tareas_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/core/app_constants.dart';
import 'package:agronova_app/screens/tareas/registro_tarea.dart';
import 'package:agronova_app/widgets/cards/card_tarea.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';

// Este es un widget separado solo para la lista
class TareasListView extends StatelessWidget {
  const TareasListView({super.key});

  void _navigateToRegistro(BuildContext context, [Tarea? tarea]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegistroTarea(tarea: tarea)),
    );
  }

  // ... (Mueve _showDeleteDialog y _showCompleteDialog aquí) ...
  void _showDeleteDialog(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Eliminar Tarea',
        content: '¿Está seguro que desea inactivar a "${tarea.nombre}"?',
        onConfirm: () {
          Provider.of<TareaProvider>(
            context,
            listen: false,
          ).deleteTarea(tarea.id!);
        },
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Completar Tarea'),
        content: Text(
          '¿Está seguro que desea marcar la tarea "${tarea.nombre}" como completada?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              final updatedTask = tarea.copyWith(estado: AppStatus.completada);
              Provider.of<TareaProvider>(
                context,
                listen: false,
              ).updateTarea(updatedTask);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);

    if (tareaProvider.isLoading) {
      return const LoadingSpinner();
    }

    if (tareaProvider.tareas.isEmpty) {
      return const Center(child: Text('No hay tareas activas registradas.'));
    }

    return ListView.builder(
      itemCount: tareaProvider.tareas.length,
      itemBuilder: (ctx, i) {
        final tarea = tareaProvider.tareas[i];
        return CardTarea(
          tarea: tarea,
          onEdit: () => _navigateToRegistro(context, tarea),
          onDelete: () => _showDeleteDialog(context, tarea),
          onMarkCompleted: () => _showCompleteDialog(context, tarea),
        );
      },
    );
  }
}
