// lib/widgets/layout/custom_drawer.dart (Actualizado)

import 'package:flutter/material.dart';
//import 'package:agronova_app/pagina_acerca.dart';
import 'package:agronova_app/pagina_inicio.dart';
import 'package:agronova_app/screens/agricultores/pagina_agricultores.dart';
import 'package:agronova_app/screens/cultivos/pagina_cultivos.dart';
import 'package:agronova_app/screens/inventario/pagina_inventario.dart';
import 'package:agronova_app/screens/mercado/pagina_mercado.dart';
import 'package:agronova_app/screens/tareas/pagina_tareas.dart';
import 'package:agronova_app/screens/catalogos/pagina_catalogo.dart'; // Importamos la página genérica
import 'package:agronova_app/models/categoria_cultivo.dart';
import 'package:agronova_app/models/tipo_insumo.dart';
import 'package:agronova_app/models/tipo_tarea.dart';
import 'package:agronova_app/models/ubicacion.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Cambiado a ListView para permitir el scroll
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Center(
              child: Text(
                'AgroNova',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          /** */
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, PaginaInicio.routeName);
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'MÓDULOS PRINCIPALES',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Cultivos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaCultivos.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaTareas.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventario / Insumos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaInventario.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Mercado / Ventas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaMercado.routeName);
            },
          ),

          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Catálogos y Configuración'),
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.only(left: 32),
                title: const Text('Categorías de Cultivo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PaginaCatalogo<
                            CategoriaCultivo,
                            CategoriaCultivoProvider
                          >(title: 'Categoría de Cultivo'),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 32),
                title: const Text('Ubicaciones'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PaginaCatalogo<Ubicacion, UbicacionProvider>(
                            title: 'Ubicación',
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 32),
                title: const Text('Tipos de Insumo'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PaginaCatalogo<TipoInsumo, TipoInsumoProvider>(
                            title: 'Tipo de Insumo',
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 32),
                title: const Text('Tipos de Tarea'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const PaginaCatalogo<TipoTarea, TipoTareaProvider>(
                            title: 'Tipo de Tarea',
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Agricultores'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PaginaAgricultores.routeName);
            },
          ),
        ],
      ),
    );
  }
}
