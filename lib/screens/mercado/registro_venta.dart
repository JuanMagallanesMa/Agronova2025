import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/venta.dart';
import 'package:agronova_app/models/venta_detalle.dart';
import 'package:agronova_app/models/producto.dart';
import 'package:agronova_app/providers/venta_provider.dart';
import 'package:agronova_app/providers/producto_provider.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
// import 'package:agronova_app/widgets/forms/date_input_field.dart'; // <-- CORRECCIÓN: Eliminado
import 'package:agronova_app/core/app_constants.dart';

class RegistroVenta extends StatefulWidget {
  final Venta? venta;
  const RegistroVenta({super.key, this.venta});

  @override
  State<RegistroVenta> createState() => _RegistroVentaState();
}

class _RegistroVentaState extends State<RegistroVenta> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isEditing = false;

  // Variables de Venta
  final DateTime _fecha = DateTime.now(); // <-- CORRECCIÓN: Eliminado
  String _nombreCliente = '';
  String _cedula = '';
  double _totalVenta = 0.0;
  List<VentaDetalle> _detalles = [];

  // Controladores
  Producto? _productoSeleccionado;
  final TextEditingController _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.venta != null;
    if (_isEditing) {
      final venta = widget.venta!;
      // _fecha = venta.fecha; // <-- CORRECCIÓN: Eliminado (Error undefined_getter)
      _nombreCliente = venta.nombreCliente;
      _cedula = venta.cedula;
      _detalles = List<VentaDetalle>.from(venta.detalles);
      _calcularTotal();
    }
  }

  void _calcularTotal() {
    double total = 0.0;
    for (var detalle in _detalles) {
      total += (detalle.cantidad * detalle.precioUnitario);
    }
    setState(() {
      _totalVenta = total;
    });
  }

  void _agregarDetalle() {
    if (_productoSeleccionado == null || _cantidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un producto y una cantidad.')),
      );
      return;
    }
    final int cantidad = int.tryParse(_cantidadController.text) ?? 0;
    if (cantidad <= 0) return;

    final producto = _productoSeleccionado!;

    final existingIndex = _detalles.indexWhere(
      (d) => d.idProducto == producto.id,
    );
    if (existingIndex != -1) {
      final oldDetalle = _detalles[existingIndex];
      setState(() {
        _detalles[existingIndex] = oldDetalle.copyWith(
          cantidad: oldDetalle.cantidad + cantidad,
        );
      });
    } else {
      setState(() {
        _detalles.add(
          VentaDetalle(
            idProducto: producto.id!,
            nombreProducto: producto.nombre,
            cantidad: cantidad,
            precioUnitario: producto.precioCaja,
          ),
        );
      });
    }

    _limpiarFormularioDetalle();
    _calcularTotal();
  }

  void _eliminarDetalle(int index) {
    setState(() {
      _detalles.removeAt(index);
      _calcularTotal();
    });
  }

  void _limpiarFormularioDetalle() {
    setState(() {
      _productoSeleccionado = null;
      _cantidadController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe agregar al menos un producto.')),
      );
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    final provider = Provider.of<VentaProvider>(context, listen: false);

    final ventaToSave = Venta(
      id: widget.venta?.id,
      fecha: _fecha, // <-- CORRECCIÓN: Eliminado
      nombreCliente: _nombreCliente,
      cedula: _cedula,
      detalles: _detalles,
      total: _totalVenta,
      estado: widget.venta?.estado ?? AppStatus.activo,
    );

    try {
      if (_isEditing) {
        // Tu VentaProvider (venta_provider.dart) no tiene un método 'updateVenta'.
        // Si necesitas editar, deberás añadir esa función en el provider.
        // Por ahora, mostraremos un aviso.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La edición de ventas no está implementada en el provider.',
            ),
          ),
        );
      } else {
        await provider.addVenta(ventaToSave);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la venta: $e')),
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
    final productoProvider = Provider.of<ProductoProvider>(context);

    return MainScaffold(
      title: _isEditing ? 'Editar Venta' : 'Registrar Venta',
      showDrawer: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- DATOS GENERALES ---
              // <-- CORRECCIÓN: DateInputField eliminado
              TextFormField(
                initialValue: _nombreCliente,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Cliente',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre del cliente.';
                  }
                  return null;
                },
                onSaved: (value) => _nombreCliente = value!,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _cedula,
                decoration: const InputDecoration(
                  labelText: 'Cédula del Cliente',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cédula del cliente.';
                  }
                  return null;
                },
                onSaved: (value) => _cedula = value!,
              ),
              const SizedBox(height: 20),

              // --- FORMULARIO DE DETALLE ---
              const Text(
                'Agregar Productos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (productoProvider.isLoading)
                const Center(child: Text('Cargando productos...'))
              else
                DropdownButtonFormField<Producto>(
                  decoration: const InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(),
                  ),
                  value: _productoSeleccionado,
                  items: productoProvider.productos.map((Producto p) {
                    return DropdownMenuItem<Producto>(
                      value: p,
                      child: Text(
                        '${p.nombre} (\$${p.precioCaja.toStringAsFixed(2)})',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _productoSeleccionado = value),
                ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir'),
                      onPressed: _agregarDetalle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- LISTA DE DETALLES ---
              const Text(
                'Productos en la Venta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (_detalles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('Aún no hay productos en la venta.'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _detalles.length,
                  itemBuilder: (ctx, i) {
                    final detalle = _detalles[i];
                    final subtotal = detalle.cantidad * detalle.precioUnitario;
                    return ListTile(
                      title: Text(detalle.nombreProducto),
                      subtitle: Text(
                        '${detalle.cantidad} x \$${detalle.precioUnitario.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _eliminarDetalle(i),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              const Divider(thickness: 1.5, height: 30),

              // --- TOTAL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '\$${_totalVenta.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              ActionButton(
                text: _isEditing ? 'Guardar Cambios' : 'Registrar Venta',
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
