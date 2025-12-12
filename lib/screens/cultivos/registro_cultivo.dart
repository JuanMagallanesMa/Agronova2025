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
  bool _isSaving = false;

  // Variables de estado
  String _nombre = '';
  String _idCategoria = '';
  String _idUbicacion = '';

  @override
  void initState() {
    super.initState();

    // 1. CORRECCIÓN: Carga de catálogos
    // Usamos addPostFrameCallback para evitar errores de construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoriaProvider = Provider.of<CategoriaCultivoProvider>(
        context,
        listen: false,
      );
      final ubicacionProvider = Provider.of<UbicacionProvider>(
        context,
        listen: false,
      );

      // Verificamos si ya tienen datos para no llamar a Firebase innecesariamente
      // (Opcional: Si quieres refrescar siempre, quita el 'if')
      if (categoriaProvider.items.isEmpty) categoriaProvider.fetchAll();
      if (ubicacionProvider.items.isEmpty) ubicacionProvider.fetchAll();
    });

    // Inicialización de datos para edición
    final cultivo = widget.cultivo;
    if (cultivo != null) {
      _nombre = cultivo.nombre;
      _idCategoria = cultivo.idCategoria;
      _idUbicacion = cultivo.idUbicacion;
    }
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
      id: widget.cultivo?.id,
      nombre: _nombre,
      idCategoria: _idCategoria,
      idUbicacion: _idUbicacion,
      estado: widget.cultivo?.estado ?? AppStatus.activo,
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
                  border: OutlineInputBorder(),
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

              // Dropdown Categoría
              // MEJORA: Un Loader visualmente más agradable
              if (categoriaProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: LinearProgressIndicator(),
                )
              else
                FormDropdownCatalogo(
                  label: 'Categoría',
                  selectedId: _idCategoria,
                  items: categoriaProvider.items,
                  onChanged: (value) => setState(() => _idCategoria = value!),
                ),
              const SizedBox(height: 15),

              // Dropdown Ubicación
              if (ubicacionProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: LinearProgressIndicator(),
                )
              else
                FormDropdownCatalogo(
                  label: 'Ubicación',
                  selectedId: _idUbicacion,
                  items: ubicacionProvider.items,
                  onChanged: (value) => setState(() => _idUbicacion = value!),
                ),
              const SizedBox(height: 30),

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
