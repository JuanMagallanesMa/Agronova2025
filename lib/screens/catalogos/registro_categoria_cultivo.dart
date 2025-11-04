// lib/screens/catalogos/registro_categoria_cultivo.dart
import 'package:agronova_app/models/categoria_cultivo.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/screens/catalogos/registro_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/referencia_base.dart';

class RegistroCategoriaCultivo extends StatelessWidget {
  final CategoriaCultivo? categoria;
  const RegistroCategoriaCultivo({super.key, this.categoria});

  @override
  Widget build(BuildContext context) {
    return RegistroCatalogo<CategoriaCultivo>(
      title: 'Categoría de Cultivo',
      item: categoria,
      onSave: (ReferenciaBase item) {
        final provider = Provider.of<CategoriaCultivoProvider>(
          context,
          listen: false,
        );
        final itemEspecifico = CategoriaCultivo(
          id: item.id,
          nombre: item.nombre,
          estado: item.estado,
        );
        return item.id.isEmpty
            ? provider.add(itemEspecifico)
            : provider.update(itemEspecifico);
      },
    );
  }
}
