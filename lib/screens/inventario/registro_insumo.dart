import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/insumo.dart';
import 'package:agronova_app/providers/insumo_provider.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/numeric_input_field.dart';
import 'package:agronova_app/widgets/forms/form_dropdown_catalogo.dart';
import 'package:agronova_app/core/app_constants.dart';

class RegistroInsumo extends StatefulWidget {
  final Insumo? insumo;

  const RegistroInsumo({super.key, this.insumo});

  @override
  State<RegistroInsumo> createState() => _RegistroInsumoState();
}

class _RegistroInsumoState extends State<RegistroInsumo> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Variables de estado
  String _descripcion = '';
  String _idTipoInsumo = '';
  int _cantidad = 0;
  String _unidadMedida = 'Kg'; // Valor por defecto seguro

  // Lista estática de unidades (podría venir de una constante o DB)
  final List<String> _unidadesDisponibles = [
    'Kg',
    'Litros',
    'Unidades',
    'Bolsas',
    'Galones',
  ];

  @override
  void initState() {
    super.initState();

    // 1. CORRECCIÓN CRÍTICA: Cargar el catálogo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TipoInsumoProvider>(context, listen: false).fetchAll();
    });

    final insumo = widget.insumo;
    if (insumo != null) {
      _descripcion = insumo.descripcion;
      _idTipoInsumo = insumo.idTipoInsumo;
      _cantidad = insumo.cantidad;

      // 2. CORRECCIÓN DE SEGURIDAD (Dropdown Crash):
      // Si la unidad que viene de la BD no está en nuestra lista hardcodeada,
      // la agregamos temporalmente o forzamos un default para evitar crash.
      // Aquí optamos por mantener el valor original aunque no esté en la lista estándar.
      if (!_unidadesDisponibles.contains(insumo.unidadMedida)) {
        _unidadesDisponibles.add(insumo.unidadMedida);
      }
      _unidadMedida = insumo.unidadMedida;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<InsumoProvider>(context, listen: false);
    final isEditing = widget.insumo != null;

    final insumoToSave = Insumo(
      id: widget.insumo?.id,
      idTipoInsumo: _idTipoInsumo,
      descripcion: _descripcion,
      cantidad: _cantidad,
      unidadMedida: _unidadMedida,
      estado: widget.insumo?.estado ?? AppStatus.activo,
    );

    try {
      if (isEditing) {
        await provider.updateInsumo(insumoToSave);
      } else {
        await provider.addInsumo(insumoToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el insumo: $e')),
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
    final isEditing = widget.insumo != null;
    final tipoInsumoProvider = Provider.of<TipoInsumoProvider>(context);

    return MainScaffold(
      title: isEditing ? 'Editar Insumo' : 'Registrar Insumo',
      showDrawer: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo Descripción
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(
                  labelText: 'Descripción del Insumo',
                  border: OutlineInputBorder(), // Un toque visual
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la descripción.';
                  }
                  return null;
                },
                onSaved: (value) => _descripcion = value!,
              ),
              const SizedBox(height: 15),

              // Dropdown Tipo de Insumo (Catálogo)
              // Usamos un AnimatedSwitcher o un simple if para UX
              if (tipoInsumoProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(child: LinearProgressIndicator()),
                )
              else
                FormDropdownCatalogo(
                  label: 'Tipo de Insumo',
                  selectedId: _idTipoInsumo,
                  items: tipoInsumoProvider.items,
                  onChanged: (value) {
                    setState(() {
                      _idTipoInsumo = value!;
                    });
                  },
                ),
              const SizedBox(height: 15),

              // Campo Cantidad
              NumericInputField(
                label: 'Cantidad en Stock',
                initialValue: _cantidad.toString(),
                isDecimal: false,
                onSaved: (value) => _cantidad = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 15),

              // Campo Unidad de Medida
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Unidad de Medida',
                  border: OutlineInputBorder(),
                ),
                value: _unidadMedida,
                items: _unidadesDisponibles.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _unidadMedida = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una unidad' : null,
              ),
              const SizedBox(height: 30),

              ActionButton(
                text: isEditing ? 'Guardar Cambios' : 'Registrar Insumo',
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
