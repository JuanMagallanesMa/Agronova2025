// lib/screens/catalogos/registro_ubicacion.dart
import 'package:agronova_app/models/ubicacion.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/screens/catalogos/registro_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/referencia_base.dart';

class RegistroUbicacion extends StatelessWidget {
  final Ubicacion? ubicacion;
  const RegistroUbicacion({super.key, this.ubicacion});

  @override
  Widget build(BuildContext context) {
    return RegistroCatalogo<Ubicacion>(
      title: 'Ubicación',
      item: ubicacion,
      onSave: (ReferenciaBase item) {
        final provider = Provider.of<UbicacionProvider>(context, listen: false);
        final itemEspecifico = Ubicacion(
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
