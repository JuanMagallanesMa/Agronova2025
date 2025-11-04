import 'package:flutter/material.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:agronova_app/models/categoria_cultivo.dart';
import 'package:agronova_app/models/ubicacion.dart';

class CardCultivo extends StatelessWidget {
  final Cultivo cultivo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardCultivo({
    super.key,
    required this.cultivo,
    required this.onEdit,
    required this.onDelete,
  });

  // Helper para obtener el nombre de la categoría usando el Provider
  String _getCategoriaNombre(BuildContext context, String id) {
    final categorias = Provider.of<CategoriaCultivoProvider>(context).items;
    return categorias
        .firstWhere(
          (c) => c.id == id,
          orElse: () => CategoriaCultivo(id: id, nombre: 'Desconocida'),
        )
        .nombre;
  }

  // Helper para obtener el nombre de la ubicación usando el Provider
  String _getUbicacionNombre(BuildContext context, String id) {
    final ubicaciones = Provider.of<UbicacionProvider>(context).items;
    return ubicaciones
        .firstWhere(
          (u) => u.id == id,
          orElse: () => Ubicacion(id: id, nombre: 'Desconocida'),
        )
        .nombre;
  }

  @override
  Widget build(BuildContext context) {
    final categoriaNombre = _getCategoriaNombre(context, cultivo.idCategoria);
    final ubicacionNombre = _getUbicacionNombre(context, cultivo.idUbicacion);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.grass, color: Colors.green),
        ),
        title: Text(
          cultivo.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoría: $categoriaNombre'),
            Text('Ubicación: $ubicacionNombre'),
            Text(
              'Inicio: ${DateFormat('yyyy-MM-dd').format(cultivo.fechaInicio)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
