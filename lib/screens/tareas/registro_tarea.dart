// lib/screens/tareas/registro_tarea.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/models/cultivo.dart';
// 1. Importar los nuevos modelos y providers necesarios
import 'package:agronova_app/models/insumo.dart';
import 'package:agronova_app/models/agricultor.dart';
import 'package:agronova_app/providers/insumo_provider.dart';
import 'package:agronova_app/providers/agricultor_provider.dart';
// ... (otros imports)
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/date_input_field.dart';
import 'package:agronova_app/widgets/forms/form_dropdown_catalogo.dart';
import 'package:agronova_app/core/app_constants.dart';

import '../../models/insumo_agregado.dart';

// Importaste un modelo 'insumo_agregado.dart', pero el que definimos
// en el paso anterior se llamaba 'insumo_asignado.dart'.
// Asegúrate de que el nombre del archivo sea el correcto.
// Voy a usar 'InsumoAsignado' como lo definimos.

class RegistroTarea extends StatefulWidget {
  final Tarea? tarea;
  const RegistroTarea({super.key, this.tarea});

  @override
  State<RegistroTarea> createState() => _RegistroTareaState();
}

class _RegistroTareaState extends State<RegistroTarea> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Variables de estado del formulario
  String _nombre = '';
  String _descripcion = '';
  String _idTipoTarea = '';
  String _idCultivo = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  List<String> _idAgricultores = [];
  List<InsumoAsignado> _insumosAsignados = [];

  // Variables temporales para los selectores de listas
  final _cantidadInsumoController = TextEditingController();
  String? _tempSelectedAgricultorId;
  String? _tempSelectedInsumoId;

  // Claves para los dropdowns (para poder resetearlos)
  final _agricultorDropdownKey = GlobalKey<FormFieldState>();
  final _insumoDropdownKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    final tarea = widget.tarea;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Usamos listen: false porque solo queremos *llamar* a la función,
        // no suscribirnos a cambios dentro de initState.

        // NOTA: Asumo que los métodos se llaman 'fetch...'.
        // ¡Verifica los nombres en tus archivos provider!
        Provider.of<TipoTareaProvider>(context, listen: false).fetchAll();
        Provider.of<CultivoProvider>(context, listen: false).fetchCultivos();
        Provider.of<AgricultorProvider>(
          context,
          listen: false,
        ).fetchAgricultores();
        Provider.of<InsumoProvider>(context, listen: false).fetchInsumos();
      }
    });
    if (tarea != null) {
      _nombre = tarea.nombre;
      _descripcion = tarea.descripcion;
      _idTipoTarea = tarea.idTipoTarea;
      _idCultivo = tarea.idCultivo;
      _fechaInicio = tarea.fechaInicio;
      _fechaFin = tarea.fechaFin;
      _idAgricultores = List<String>.from(tarea.idAgricultores); // Copia segura
      _insumosAsignados = List<InsumoAsignado>.from(
        tarea.insumosAsignados.map(
          (ia) => ia.copyWith(), // Copia profunda
        ),
      );
    }
  }

  @override
  void dispose() {
    _cantidadInsumoController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<TareaProvider>(context, listen: false);
    final isEditing = widget.tarea != null;

    final tareaToSave = Tarea(
      id: widget.tarea?.id,
      nombre: _nombre,
      descripcion: _descripcion,
      idTipoTarea: _idTipoTarea,
      idCultivo: _idCultivo,
      fechaInicio: _fechaInicio!,
      fechaFin: _fechaFin!,
      estado: widget.tarea?.estado ?? AppStatus.pendiente,

      idAgricultores: _idAgricultores,
      insumosAsignados: _insumosAsignados,
    );

    try {
      if (isEditing) {
        await provider.updateTarea(tareaToSave);
      } else {
        await provider.addTarea(tareaToSave);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la tarea: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // --- UI Widgets para las listas ---

  Widget _buildAgricultoresChips(AgricultorProvider agricultorProvider) {
    if (_idAgricultores.isEmpty) {
      return const Text('Aún no se han asignado agricultores.');
    }

    final agricultoresAsignados = _idAgricultores.map((id) {
      try {
        // --- CORRECCIÓN 1 (items -> agricultores) ---
        return agricultorProvider.agricultores.firstWhere((a) => a.id == id);
      } catch (e) {
        return null; // El agricultor fue borrado o no está cargado
      }
    }).whereType<Agricultor>(); // Filtra los nulos

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: agricultoresAsignados.map((agricultor) {
        return Chip(
          label: Text(agricultor.nombre),
          onDeleted: () {
            setState(() {
              _idAgricultores.remove(agricultor.id);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildInsumosList(InsumoProvider insumoProvider) {
    if (_insumosAsignados.isEmpty) {
      return const Text('Aún no se han asignado insumos.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _insumosAsignados.length,
      itemBuilder: (ctx, index) {
        final asignacion = _insumosAsignados[index];
        String insumoNombre = 'Insumo no encontrado';
        try {
          // --- CORRECCIÓN 2 (items -> insumos) ---
          final insumo = insumoProvider.insumos.firstWhere(
            (i) => i.id == asignacion.idInsumo,
          );
          // --- CORRECCIÓN 3 (nombre -> descripcion) ---
          insumoNombre = insumo.descripcion;
        } catch (e) {
          /* Mantener nombre por defecto */
        }

        return ListTile(
          title: Text(insumoNombre),
          subtitle: Text('Cantidad: ${asignacion.cantidad}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _insumosAsignados.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tarea != null;

    final tipoTareaProvider = Provider.of<TipoTareaProvider>(context);
    final cultivoProvider = Provider.of<CultivoProvider>(context);
    final agricultorProvider = Provider.of<AgricultorProvider>(context);
    final insumoProvider = Provider.of<InsumoProvider>(context);

    if (tipoTareaProvider.isLoading ||
        cultivoProvider.isLoading ||
        agricultorProvider.isLoading ||
        insumoProvider.isLoading) {
      return MainScaffold(
        title: isEditing ? 'Editar Tarea' : 'Registrar Tarea',
        showDrawer: false,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return MainScaffold(
      title: isEditing ? 'Editar Tarea' : 'Registrar Tarea',
      showDrawer: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ... (Campos de Nombre, Tipo Tarea, Cultivo, Descripción, Fechas) ...
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Tarea',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre.';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 15),
              FormDropdownCatalogo(
                label: 'Tipo de Tarea',
                selectedId: _idTipoTarea,
                items: tipoTareaProvider.items,
                onChanged: (value) {
                  setState(() => _idTipoTarea = value!);
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Cultivo Asignado',
                  border: OutlineInputBorder(),
                ),
                value: _idCultivo.isEmpty ? null : _idCultivo,
                items: cultivoProvider.cultivos.map((Cultivo cultivo) {
                  return DropdownMenuItem<String>(
                    value: cultivo.id,
                    child: Text(cultivo.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _idCultivo = value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleccione un cultivo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la Tarea',
                ),
                maxLines: 3,
                onSaved: (value) => _descripcion = value ?? '',
              ),
              const SizedBox(height: 15),
              DateInputField(
                label: 'Fecha de Inicio',
                selectedDate: _fechaInicio,
                onDateSelected: (date) {
                  setState(() => _fechaInicio = date);
                },
              ),
              const SizedBox(height: 15),
              DateInputField(
                label: 'Fecha de Fin',
                selectedDate: _fechaFin,
                onDateSelected: (date) {
                  setState(() => _fechaFin = date);
                },
              ),
              const SizedBox(height: 25),

              // --- 10. NUEVO: Selector de Agricultores ---
              Text(
                'Asignar Agricultores',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: _agricultorDropdownKey,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Agricultor',
                  border: OutlineInputBorder(),
                ),
                value: _tempSelectedAgricultorId,
                // --- CORRECCIÓN 4 (items -> agricultores) ---
                items: agricultorProvider.agricultores
                    .where((a) => !_idAgricultores.contains(a.id))
                    .map((Agricultor a) {
                      return DropdownMenuItem<String>(
                        value: a.id,
                        child: Text(a.nombre),
                      );
                    })
                    .toList(),
                onChanged: (value) {
                  setState(() => _tempSelectedAgricultorId = value);
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Añadir Agricultor'),
                onPressed: () {
                  if (_tempSelectedAgricultorId != null &&
                      !_idAgricultores.contains(_tempSelectedAgricultorId)) {
                    setState(() {
                      _idAgricultores.add(_tempSelectedAgricultorId!);
                      _tempSelectedAgricultorId = null; // Reset dropdown
                      _agricultorDropdownKey.currentState?.reset();
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildAgricultoresChips(agricultorProvider), // Lista de chips

              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 15),

              // --- 11. NUEVO: Selector de Insumos con Cantidad ---
              Text(
                'Asignar Insumos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: _insumoDropdownKey,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Insumo',
                  border: OutlineInputBorder(),
                ),
                value: _tempSelectedInsumoId,
                // --- CORRECCIÓN 5 (items -> insumos) ---
                items: insumoProvider.insumos.map((Insumo i) {
                  return DropdownMenuItem<String>(
                    value: i.id,
                    // --- CORRECCIÓN 6 (nombre -> descripcion) ---
                    child: Text(i.descripcion),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _tempSelectedInsumoId = value);
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _cantidadInsumoController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Añadir Insumo'),
                onPressed: () {
                  final cantidad = double.tryParse(
                    _cantidadInsumoController.text,
                  );
                  if (_tempSelectedInsumoId != null &&
                      cantidad != null &&
                      cantidad > 0) {
                    final yaExiste = _insumosAsignados.any(
                      (ia) => ia.idInsumo == _tempSelectedInsumoId,
                    );

                    if (yaExiste) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Este insumo ya fue añadido. Bórrelo para modificarlo.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _insumosAsignados.add(
                        InsumoAsignado(
                          idInsumo: _tempSelectedInsumoId!,
                          cantidad: cantidad,
                        ),
                      );
                      _tempSelectedInsumoId = null;
                      _cantidadInsumoController.clear();
                      _insumoDropdownKey.currentState?.reset();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Seleccione un insumo e ingrese una cantidad válida.',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              _buildInsumosList(insumoProvider), // Lista de insumos añadidos

              const SizedBox(height: 30),
              ActionButton(
                text: isEditing ? 'Guardar Cambios' : 'Registrar Tarea',
                onPressed: _saveForm,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
