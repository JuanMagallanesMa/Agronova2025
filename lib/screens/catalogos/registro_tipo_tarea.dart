// lib/screens/catalogos/registro_tipo_tarea.dart
import 'package:agronova_app/models/tipo_tarea.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';
import 'package:agronova_app/screens/catalogos/registro_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/referencia_base.dart';

class RegistroTipoTarea extends StatelessWidget {
  final TipoTarea? tipo;
  const RegistroTipoTarea({super.key, this.tipo});

  @override
  Widget build(BuildContext context) {
    return RegistroCatalogo<TipoTarea>(
      title: 'Tipo de Tarea',
      item: tipo,
      onSave: (ReferenciaBase item) {
        final provider = Provider.of<TipoTareaProvider>(context, listen: false);
        final itemEspecifico = TipoTarea(
          id: item.id,
          nombre: item.nombre,
          estado: item.estado,
        );
        return item.id!.isEmpty
            ? provider.add(itemEspecifico)
            : provider.update(itemEspecifico);
      },
    );
  }
}
