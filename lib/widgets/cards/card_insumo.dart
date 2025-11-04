import 'package:flutter/material.dart';
import 'package:agronova_app/models/insumo.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tipo_insumo.dart';

class CardInsumo extends StatelessWidget {
  final Insumo insumo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardInsumo({
    super.key,
    required this.insumo,
    required this.onEdit,
    required this.onDelete,
  });

  // Helper para obtener el nombre del tipo de insumo
  String _getTipoInsumoNombre(BuildContext context, String id) {
    final tipos = Provider.of<TipoInsumoProvider>(context).items;
    return tipos
        .firstWhere(
          (t) => t.id == id,
          orElse: () => TipoInsumo(id: id, nombre: 'Desconocido'),
        )
        .nombre;
  }

  @override
  Widget build(BuildContext context) {
    final tipoInsumoNombre = _getTipoInsumoNombre(context, insumo.idTipoInsumo);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.storage, color: Colors.blue),
        ),
        title: Text(
          insumo.descripcion,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: $tipoInsumoNombre'),
            Text('Cantidad: ${insumo.cantidad} ${insumo.unidadMedida}'),
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
