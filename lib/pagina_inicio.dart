import 'package:flutter/material.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/screens/cultivos/pagina_cultivos.dart';
import 'package:agronova_app/screens/tareas/pagina_tareas.dart';
import 'package:agronova_app/screens/inventario/pagina_inventario.dart';
import 'package:agronova_app/screens/agricultores/pagina_agricultores.dart';
import 'package:agronova_app/screens/productos/pagina_productos.dart';
import 'package:agronova_app/screens/mercado/pagina_mercado.dart';
//import 'package:agronova_app/screens/catalogos/pagina_catalogo.dart';

class PaginaInicio extends StatelessWidget {
  static const String routeName = '/inicio';
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Dashboard - AgriGestor',
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Sección Operativa ---
          const _SectionTitle(title: 'MÓDULOS OPERATIVOS'),
          const SizedBox(height: 10),
          _DashboardCard(
            icon: Icons.eco,
            title: 'Cultivos',
            subtitle: 'Gestiona tus cultivos activos.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaCultivos.routeName);
            },
          ),
          _DashboardCard(
            icon: Icons.list_alt,
            title: 'Tareas',
            subtitle: 'Asigna y completa tareas.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaTareas.routeName);
            },
          ),
          _DashboardCard(
            icon: Icons.inventory_2,
            title: 'Inventario',
            subtitle: 'Controla tus insumos.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaInventario.routeName);
            },
          ),
          _DashboardCard(
            icon: Icons.people,
            title: 'Agricultores',
            subtitle: 'Administra tu personal.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaAgricultores.routeName);
            },
          ),
          _DashboardCard(
            icon: Icons.shopping_basket,
            title: 'Productos',
            subtitle: 'Gestiona la cosecha lista.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaProductos.routeName);
            },
          ),
          _DashboardCard(
            icon: Icons.storefront,
            title: 'Mercado (Ventas)',
            subtitle: 'Registra las ventas.',
            onTap: () {
              Navigator.of(context).pushNamed(PaginaMercado.routeName);
            },
          ),

          const SizedBox(height: 20),
          /** 
          // --- Sección de Administración ---
          const _SectionTitle(title: 'ADMINISTRACIÓN'),
          const SizedBox(height: 10),
          _DashboardCard(
            icon: Icons.settings,
            title: 'Catálogos',
            subtitle: 'Configura tipos, ubicaciones, etc.',
            color: Colors.grey.shade700,
            onTap: () {
              Navigator.of(context).pushNamed(PaginaCatalogo.routeName);
            },
          ),
          */
        ],
      ),
    );
  }
}

// Widget interno para los Títulos de Sección
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

// Widget interno para las tarjetas (ahora como ListTile)
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    // ignore: unused_element_parameter
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).primaryColorDark;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: cardColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
