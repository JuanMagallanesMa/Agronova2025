import 'package:flutter/material.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/models/tipo_tarea.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CardTarea extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkCompleted;

  const CardTarea({
    super.key,
    required this.tarea,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkCompleted,
  });

  // Helper para obtener el nombre del tipo de tarea
  String _getTipoTareaNombre(BuildContext context, String id) {
    final tipos = Provider.of<TipoTareaProvider>(context).items;
    return tipos
        .firstWhere(
          (t) => t.id == id,
          orElse: () => TipoTarea(id: id, nombre: 'Desconocida'),
        )
        .nombre;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final estadoColor = tarea.estado == 'Completada'
        ? Colors.green
        : Colors.orange;
    final tipoTareaNombre = _getTipoTareaNombre(context, tarea.idTipoTarea);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: estadoColor.shade100,
          child: Icon(Icons.assignment, color: estadoColor),
        ),
        title: Text(
          '${tarea.nombre} (${tarea.estado})',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: estadoColor,
            decoration: tarea.estado == 'Completada'
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cultivo ID: ${tarea.idCultivo}',
            ), // Idealmente, se usaría CultivoProvider para el nombre
            Text('Tipo: $tipoTareaNombre'),
            Text(
              'Período: ${dateFormat.format(tarea.fechaInicio)} a ${dateFormat.format(tarea.fechaFin)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tarea.estado != 'Completada')
              IconButton(
                icon: const Icon(Icons.done_all, color: Colors.green),
                onPressed: onMarkCompleted,
                tooltip: 'Marcar como Completada',
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
