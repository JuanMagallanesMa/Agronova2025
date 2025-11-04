import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/agricultor.dart';
import 'package:agronova_app/providers/agricultor_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/numeric_input_field.dart';
import 'package:agronova_app/core/app_constants.dart';

class RegistroAgricultor extends StatefulWidget {
  final Agricultor? agricultor;

  const RegistroAgricultor({super.key, this.agricultor});

  @override
  State<RegistroAgricultor> createState() => _RegistroAgricultorState();
}

class _RegistroAgricultorState extends State<RegistroAgricultor> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Variables temporales
  String _nombre = '';
  int? _edad;
  String _zona = '';
  String _experiencia = '';

  @override
  void initState() {
    super.initState();
    final agricultor = widget.agricultor;
    if (agricultor != null) {
      _nombre = agricultor.nombre;
      _edad = agricultor.edad;
      _zona = agricultor.zona;
      _experiencia = agricultor.experiencia;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<AgricultorProvider>(context, listen: false);
    final isEditing = widget.agricultor != null;

    final agricultorToSave = Agricultor(
      id: widget.agricultor?.id,
      nombre: _nombre,
      edad: _edad,
      zona: _zona,
      experiencia: _experiencia,
      estado: widget.agricultor?.estado ?? AppStatus.activo,
    );

    try {
      if (isEditing) {
        await provider.updateAgricultor(agricultorToSave);
      } else {
        await provider.addAgricultor(agricultorToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el agricultor: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.agricultor != null;

    return MainScaffold(
      title: isEditing ? 'Editar Agricultor' : 'Registrar Agricultor',
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
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre.';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 15),
              NumericInputField(
                label: 'Edad (Opcional)',
                initialValue: _edad?.toString() ?? '',
                isDecimal: false,
                onSaved: (value) => _edad = int.tryParse(value),
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _zona,
                decoration: const InputDecoration(labelText: 'Zona/Vereda'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la zona.';
                  }
                  return null;
                },
                onSaved: (value) => _zona = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _experiencia,
                decoration: const InputDecoration(
                  labelText: 'Experiencia (Años/Cultivos)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la experiencia.';
                  }
                  return null;
                },
                onSaved: (value) => _experiencia = value!,
              ),
              const SizedBox(height: 30),
              ActionButton(
                text: isEditing ? 'Guardar Cambios' : 'Registrar Agricultor',
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
