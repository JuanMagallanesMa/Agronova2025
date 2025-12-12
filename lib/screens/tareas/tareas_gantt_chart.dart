// En: screens/tareas/widgets/tareas_gantt_view.dart

import 'package:agronova_app/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';

// --- CORRECCIÓN 1: Imports Faltantes ---
import 'package:gantt_chart/gantt_chart.dart'; // <--- Este es el import correcto

class TareasGanttView extends StatefulWidget {
  const TareasGanttView({super.key});

  @override
  State<TareasGanttView> createState() => _TareasGanttViewState();
}

class _TareasGanttViewState extends State<TareasGanttView> {
  DateTime? _selectedDate;

  // --- (Las funciones _selectDate y _clearFilter que teníamos están perfectas) ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDate = null;
    });
  }
  // --- Fin de funciones de fecha ---

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);

    if (tareaProvider.isLoading) {
      return const LoadingSpinner();
    }

    // 1. Filtrar las tareas (Lógica sin cambios)
    final List<Tarea> tareasFiltradas = _selectedDate == null
        ? tareaProvider.tareas
        : tareaProvider.tareas.where((t) {
            final start = DateTime(
              t.fechaInicio.year,
              t.fechaInicio.month,
              t.fechaInicio.day,
            );
            final end = DateTime(
              t.fechaFin.year,
              t.fechaFin.month,
              t.fechaFin.day,
            );
            final selected = DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
            );

            return (selected.isAtSameMomentAs(start) ||
                    selected.isAfter(start)) &&
                (selected.isAtSameMomentAs(end) || selected.isBefore(end));
          }).toList();

    // 2. Convertir Tarea a GanttAbsoluteEvent  <--- CORREGIDO
    // Usamos GanttEventBase que es la clase padre, y GanttAbsoluteEvent
    // que es perfecta para "fechaInicio" y "fechaFin".
    final List<GanttEventBase> ganttEvents = tareasFiltradas.map((tarea) {
      return GanttAbsoluteEvent(
        displayName: tarea.nombre,
        startDate: tarea.fechaInicio,
        endDate: tarea.fechaFin,
        suggestedColor: _getColorForStatus(tarea.estado), // Color según estado
      );
    }).toList();

    // 3. Renderizar el GanttChartView <--- CORREGIDO
    return Column(
      children: [
        // --- (El widget del filtro de fecha se queda igual) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrar por fecha:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _selectedDate == null
                          ? 'Mostrar Todas'
                          : MaterialLocalizations.of(
                              context,
                            ).formatShortDate(_selectedDate!),
                    ),
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: _clearFilter,
                    ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 4. Mensaje si no hay tareas (sin cambios)
        if (tareasFiltradas.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No hay tareas para la fecha seleccionada.'),
            ),
          )
        // 5. Mostrar el Gantt si hay tareas <--- CORREGIDO
        else
          Expanded(
            child: GanttChartView(
              // --- Parámetros de Configuración ---
              maxDuration: const Duration(days: 180), // Rango total visible
              startDate: tareaProvider.tareas.isNotEmpty
                  ? _getStartDate(
                      tareaProvider.tareas,
                    ) // Calcula la fecha más temprana
                  : DateTime.now().subtract(const Duration(days: 30)),
              dayWidth: 40.0, // Ancho de cada día
              eventHeight: 40.0, // Alto de cada barra de tarea
              stickyAreaWidth: 200.0, // Ancho del área de etiquetas (nombres)
              showDays: true,

              // --- Datos ---
              events: ganttEvents, // <--- Se pasa la lista de eventos corregida
            ),
          ),
      ],
    );
  }

  // Pequeña función helper para encontrar la fecha más temprana
  DateTime _getStartDate(List<Tarea> tareas) {
    return tareas
        .map((t) => t.fechaInicio)
        .reduce((min, e) => e.isBefore(min) ? e : min)
        .subtract(const Duration(days: 2)); // Damos un margen
  }

  Color _getColorForStatus(String estado) {
    switch (estado) {
      case AppStatus.completada:
        return Colors.green;
      case AppStatus.pendiente:
        return Colors.orange;

      case AppStatus.inactivo: // Vi este en tu código anterior
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
