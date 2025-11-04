import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/tarea.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/date_input_field.dart';
import 'package:agronova_app/widgets/forms/form_dropdown_catalogo.dart';
import 'package:agronova_app/core/app_constants.dart';

class RegistroTarea extends StatefulWidget {
  final Tarea? tarea;

  const RegistroTarea({super.key, this.tarea});

  @override
  State<RegistroTarea> createState() => _RegistroTareaState();
}

class _RegistroTareaState extends State<RegistroTarea> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Variables temporales
  String _nombre = '';
  String _descripcion = '';
  String _idTipoTarea = '';
  String _idCultivo = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  List<String> _idAgricultores = [];
  List<String> _idInsumos = [];

  @override
  void initState() {
    super.initState();
    final tarea = widget.tarea;
    if (tarea != null) {
      _nombre = tarea.nombre;
      _descripcion = tarea.descripcion;
      _idTipoTarea = tarea.idTipoTarea;
      _idCultivo = tarea.idCultivo;
      _fechaInicio = tarea.fechaInicio;
      _fechaFin = tarea.fechaFin;
      _idAgricultores = tarea.idAgricultores;
      _idInsumos = tarea.idInsumos;
    }
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
      // Estado se maneja en el provider (Pendiente al crear)
      estado: widget.tarea?.estado ?? AppStatus.pendiente,
      // N:M - En un formulario real, estos IDs vendrían de un multi-selector
      idAgricultores: _idAgricultores,
      idInsumos: _idInsumos,
    );

    try {
      if (isEditing) {
        await provider.updateTarea(tareaToSave);
      } else {
        await provider.addTarea(tareaToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tarea != null;
    final tipoTareaProvider = Provider.of<TipoTareaProvider>(context);
    final cultivoProvider = Provider.of<CultivoProvider>(context);

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
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre de la Tarea'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre.';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 15),

              // Dropdown Tipo de Tarea (Catálogo)
              if (!tipoTareaProvider.isLoading)
                FormDropdownCatalogo(
                  label: 'Tipo de Tarea',
                  selectedId: _idTipoTarea,
                  items: tipoTareaProvider.items,
                  onChanged: (value) {
                    setState(() {
                      _idTipoTarea = value!;
                    });
                  },
                ),
              if (tipoTareaProvider.isLoading)
                const Center(child: Text('Cargando tipos de tarea...')),
              const SizedBox(height: 15),

              // Dropdown Cultivo (No es Catálogo base)
              if (!cultivoProvider.isLoading)
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
                    setState(() {
                      _idCultivo = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un cultivo.';
                    }
                    return null;
                  },
                ),
              if (cultivoProvider.isLoading)
                const Center(child: Text('Cargando cultivos...')),
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
                  setState(() {
                    _fechaInicio = date;
                  });
                },
              ),
              const SizedBox(height: 15),
              DateInputField(
                label: 'Fecha de Fin',
                selectedDate: _fechaFin,
                onDateSelected: (date) {
                  setState(() {
                    _fechaFin = date;
                  });
                },
              ),
              const SizedBox(height: 15),
              
              // Aquí irían los multi-selectores para Agricultores e Insumos
              // Por ahora, se guardarán vacíos.

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