import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/screens/tareas/registro_tarea.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tarea.dart';

import 'tareas_gantt_chart.dart';
import 'tareas_list_view.dart';

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
    // La lógica de fetch sigue aquí, lo cual es perfecto.
    // Alimentará a ambos tabs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TareaProvider>(context, listen: false).fetchTareas();
      }
    });
  }

  void _navigateToRegistro([Tarea? tarea]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegistroTarea(tarea: tarea)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para sincronizar el TabBar y el TabBarView
    return DefaultTabController(
      length: 2, // Dos pestañas: Lista y Gantt
      child: MainScaffold(
        title: 'Gestión de Tareas',
        trailingAppBar: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _navigateToRegistro(),
        ),
        // Pasamos el TabBar al 'bottom' del AppBar de tu MainScaffold
        // (Asumiendo que MainScaffold tiene una propiedad 'bottomAppBar' o similar)
        // Si MainScaffold no lo tiene, modifica MainScaffold para aceptarlo.
        bottomAppBar: const TabBar(
          labelColor: Colors.white, // Color del texto de la pestaña activa
          unselectedLabelColor:
              Colors.white70, // Color del texto de las pestañas inactivas
          indicatorColor: Colors.white, // Color de la línea indicadora
          tabs: [
            Tab(icon: Icon(Icons.list), text: 'Lista'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Gantt'),
          ],
        ),
        // El cuerpo es ahora un TabBarView que contiene nuestras dos vistas
        body: const TabBarView(
          children: [
            // Vista 1: La lista (refactorizada)
            TareasListView(),
            // Vista 2: El Gantt (nuevo)
            TareasGanttView(),
          ],
        ),
      ),
    );
  }
}