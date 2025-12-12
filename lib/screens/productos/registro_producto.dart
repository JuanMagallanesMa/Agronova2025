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

  // Variables de estado
  String _nombre = '';
  String _descripcion = '';
  int _cantidadStock = 0;
  double _precioCaja = 0.0;
  String? _idCultivo; // Cambiado a nullable para mejor manejo del Dropdown

  @override
  void initState() {
    super.initState();

    // 1. CORRECCIÓN: Carga de Cultivos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cultivoProvider = Provider.of<CultivoProvider>(
        context,
        listen: false,
      );
      if (cultivoProvider.cultivos.isEmpty) {
        cultivoProvider.fetchCultivos();
      }
    });

    final producto = widget.producto;
    if (producto != null) {
      _nombre = producto.nombre;
      _descripcion = producto.descripcion;
      _cantidadStock = producto.cantidadStock;
      _precioCaja = producto.precioCaja;
      _idCultivo = producto.idCultivo; // Puede ser un ID que ya no exista
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
      idCultivo:
          _idCultivo!, // Asumimos que el validador ya aseguró que no es null
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.producto != null;
    final cultivoProvider = Provider.of<CultivoProvider>(context);

    // 2. SEGURIDAD: Verificar si el _idCultivo actual existe en la lista cargada
    // Si la lista ya cargó y el ID no está, reseteamos a null para evitar crash
    // (Opcional: podrías mostrar un texto de "Cultivo eliminado")
    if (!cultivoProvider.isLoading &&
        _idCultivo != null &&
        _idCultivo!.isNotEmpty &&
        !cultivoProvider.cultivos.any((c) => c.id == _idCultivo)) {
      _idCultivo = null;
    }

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
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onSaved: (value) => _descripcion = value ?? '',
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: NumericInputField(
                      label: 'Stock',
                      initialValue: _cantidadStock.toString(),
                      isDecimal: false,
                      onSaved: (value) =>
                          _cantidadStock = int.tryParse(value) ?? 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NumericInputField(
                      label: 'Precio Unit.',
                      initialValue: _precioCaja.toString(),
                      isDecimal: true,
                      onSaved: (value) =>
                          _precioCaja = double.tryParse(value) ?? 0.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Dropdown para Cultivo
              if (cultivoProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: LinearProgressIndicator(),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Cultivo de Origen',
                    border: OutlineInputBorder(),
                  ),
                  // Usamos el _idCultivo verificado
                  value: _idCultivo,
                  items: cultivoProvider.cultivos.map((Cultivo cultivo) {
                    return DropdownMenuItem<String>(
                      value: cultivo.id,
                      child: Text(cultivo.nombre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _idCultivo = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un cultivo.';
                    }
                    return null;
                  },
                ),

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
