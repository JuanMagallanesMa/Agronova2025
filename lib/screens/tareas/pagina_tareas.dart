// Import duplicado eliminado
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/screens/tareas/registro_tarea.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tarea.dart';
// Import necesario para los estados
import 'package:agronova_app/core/app_constants.dart'; 
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/cards/card_tarea.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';

class PaginaTareas extends StatefulWidget {
  static const String routeName = '/tareas';
  const PaginaTareas({super.key});

  @override
  State<PaginaTareas> createState() => _PaginaTareasState();
}

class _PaginaTareasState extends State<PaginaTareas> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TareaProvider>(
        context,
        listen: false,
      ).fetchTareas(),
    );
  }

  void _navigateToRegistro([Tarea? tarea]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistroTarea(tarea: tarea),
      ),
    );
  }

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

  // --- NUEVO ---
  // Función para confirmar y marcar la tarea como completada
  void _showCompleteDialog(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Completar Tarea'),
        content: Text(
            '¿Está seguro que desea marcar la tarea "${tarea.nombre}" como completada?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () {
              // Usamos copyWith para crear una nueva instancia solo con el estado cambiado
              final updatedTask =
                  tarea.copyWith(estado: AppStatus.completado);

              Provider.of<TareaProvider>(
                context,
                listen: false,
              ).updateTarea(updatedTask); // Llamamos al update general

              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
  // --- FIN NUEVO ---

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);

    return MainScaffold(
      title: 'Gestión de Tareas',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: tareaProvider.isLoading
          ? const LoadingSpinner()
          : tareaProvider.tareas.isEmpty
              ? const Center(
                  // Corrección de texto: "activos" -> "activas"
                  child: Text('No hay tareas activas registradas.'),
                )
              : ListView.builder(
                  itemCount: tareaProvider.tareas.length,
                  itemBuilder: (ctx, i) {
                    final tarea = tareaProvider.tareas[i];
                    return CardTarea(
                      tarea: tarea,
                      onEdit: () => _navigateToRegistro(tarea),
                      onDelete: () => _showDeleteDialog(context, tarea),
                      // --- CORREGIDO ---
                      // Se implementa la llamada a la función de completar
                      onMarkCompleted: () => _showCompleteDialog(context, tarea),
                      // --- FIN CORREGIDO ---
                    );
                  },
                ),
    );
  }
}