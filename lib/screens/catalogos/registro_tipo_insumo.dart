// lib/screens/catalogos/registro_tipo_insumo.dart
import 'package:agronova_app/models/tipo_insumo.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:agronova_app/screens/catalogos/registro_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/referencia_base.dart';

class RegistroTipoInsumo extends StatelessWidget {
  final TipoInsumo? tipo;
  const RegistroTipoInsumo({super.key, this.tipo});

  @override
  Widget build(BuildContext context) {
    return RegistroCatalogo<TipoInsumo>(
      title: 'Tipo de Insumo',
      item: tipo,
      onSave: (ReferenciaBase item) {
        final provider = Provider.of<TipoInsumoProvider>(
          context,
          listen: false,
        );
        final itemEspecifico = TipoInsumo(
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
