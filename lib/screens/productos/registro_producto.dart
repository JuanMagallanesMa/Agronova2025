import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/producto.dart';
import 'package:agronova_app/models/cultivo.dart';
import 'package:agronova_app/providers/producto_provider.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
import 'package:agronova_app/widgets/forms/numeric_input_field.dart';
import 'package:agronova_app/core/app_constants.dart';

class RegistroProducto extends StatefulWidget {
  final Producto? producto;

  const RegistroProducto({super.key, this.producto});

  @override
  State<RegistroProducto> createState() => _RegistroProductoState();
}

class _RegistroProductoState extends State<RegistroProducto> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Variables temporales
  String _nombre = '';
  String _descripcion = '';
  int _cantidadStock = 0;
  double _precioCaja = 0.0;
  String _idCultivo = '';

  @override
  void initState() {
    super.initState();
    final producto = widget.producto;
    if (producto != null) {
      _nombre = producto.nombre;
      _descripcion = producto.descripcion;
      _cantidadStock = producto.cantidadStock;
      _precioCaja = producto.precioCaja;
      _idCultivo = producto.idCultivo;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<ProductoProvider>(context, listen: false);
    final isEditing = widget.producto != null;

    final productoToSave = Producto(
      id: widget.producto?.id,
      nombre: _nombre,
      descripcion: _descripcion,
      cantidadStock: _cantidadStock,
      precioCaja: _precioCaja,
      idCultivo: _idCultivo,
      estado: widget.producto?.estado ?? AppStatus.activo,
    );

    try {
      if (isEditing) {
        await provider.updateProducto(productoToSave);
      } else {
        await provider.addProducto(productoToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.producto != null;
    final cultivoProvider = Provider.of<CultivoProvider>(context);

    return MainScaffold(
      title: isEditing ? 'Editar Producto' : 'Registrar Producto',
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
                decoration: const InputDecoration(
                  labelText: 'Nombre del Producto',
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
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _descripcion = value ?? '',
              ),
              const SizedBox(height: 15),
              NumericInputField(
                label: 'Stock (Cantidad disponible)',
                initialValue: _cantidadStock.toString(),
                isDecimal: false,
                onSaved: (value) => _cantidadStock = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 15),
              NumericInputField(
                label: 'Precio por Caja/Unidad',
                initialValue: _precioCaja.toString(),
                isDecimal: true,
                onSaved: (value) => _precioCaja = double.tryParse(value) ?? 0.0,
              ),
              const SizedBox(height: 15),

              // Dropdown para Cultivo (No es un catálogo base)
              if (!cultivoProvider.isLoading)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Cultivo de Origen',
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

              const SizedBox(height: 30),
              ActionButton(
                text: isEditing ? 'Guardar Cambios' : 'Registrar Producto',
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
