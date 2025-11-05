import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/form_dropdown_catalogo.dart';
import 'package:agronova_app/core/app_constants.dart';

class RegistroCultivo extends StatefulWidget {
  final Cultivo? cultivo;

  const RegistroCultivo({super.key, this.cultivo});

  @override
  State<RegistroCultivo> createState() => _RegistroCultivoState();
}

class _RegistroCultivoState extends State<RegistroCultivo> {
  final _formKey = GlobalKey<FormState>();
  late Cultivo _editedCultivo;
  bool _isSaving = false;

  // Variables temporales para el formulario
  String _nombre = '';
  String _idCategoria = '';
  String _idUbicacion = '';

  @override
  void initState() {
    super.initState();
    _editedCultivo =
        widget.cultivo ??
        Cultivo(
          nombre: '',
          idCategoria: '',
          idUbicacion: '',
        );

    _nombre = _editedCultivo.nombre;
    _idCategoria = _editedCultivo.idCategoria;
    _idUbicacion = _editedCultivo.idUbicacion;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<CultivoProvider>(context, listen: false);
    final isEditing = widget.cultivo != null;

    final cultivoToSave = Cultivo(
      id: _editedCultivo.id,
      nombre: _nombre,
      idCategoria: _idCategoria,
      idUbicacion: _idUbicacion,
      estado: _editedCultivo.estado ?? AppStatus.activo,
    );

    try {
      if (isEditing) {
        await provider.updateCultivo(cultivoToSave);
      } else {
        await provider.addCultivo(cultivoToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el cultivo: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cultivo != null;
    final categoriaProvider = Provider.of<CategoriaCultivoProvider>(context);
    final ubicacionProvider = Provider.of<UbicacionProvider>(context);

    return MainScaffold(
      title: isEditing ? 'Editar Cultivo' : 'Registrar Cultivo',
      showDrawer: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo Nombre
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Cultivo',
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

              // Dropdown Categoría (Catálogo)
              if (!categoriaProvider.isLoading)
                FormDropdownCatalogo(
                  label: 'Categoría',
                  selectedId: _idCategoria,
                  items: categoriaProvider.items,
                  onChanged: (value) {
                    setState(() {
                      _idCategoria = value!;
                    });
                  },
                ),
              if (categoriaProvider.isLoading)
                const Center(child: Text('Cargando categorías...')),
              const SizedBox(height: 15),

              // Dropdown Ubicación (Catálogo)
              if (!ubicacionProvider.isLoading)
                FormDropdownCatalogo(
                  label: 'Ubicación',
                  selectedId: _idUbicacion,
                  items: ubicacionProvider.items,
                  onChanged: (value) {
                    setState(() {
                      _idUbicacion = value!;
                    });
                  },
                ),
              if (ubicacionProvider.isLoading)
                const Center(child: Text('Cargando ubicaciones...')),
              const SizedBox(height: 15),

              ActionButton(
                text: isEditing ? 'Guardar Cambios' : 'Registrar Cultivo',
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
