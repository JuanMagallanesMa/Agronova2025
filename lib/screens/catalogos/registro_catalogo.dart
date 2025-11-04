// lib/screens/catalogos/registro_catalogo.dart
import 'package:flutter/material.dart';
import 'package:agronova_app/models/referencia_base.dart';
import 'package:agronova_app/widgets/shared/action_button.dart';
//import 'package:provider/provider.dart';

// Tipo genérico para la función de guardado
typedef SaveFunction<T extends ReferenciaBase> = Future<void> Function(T item);

class RegistroCatalogo<T extends ReferenciaBase> extends StatefulWidget {
  final T? item;
  final String title;
  final SaveFunction<T> onSave;

  const RegistroCatalogo({
    super.key,
    this.item,
    required this.title,
    required this.onSave,
  });

  @override
  State<RegistroCatalogo> createState() => _RegistroCatalogoState<T>();
}

class _RegistroCatalogoState<T extends ReferenciaBase>
    extends State<RegistroCatalogo<T>> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _estado = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombre = widget.item?.nombre ?? '';
    _estado = widget.item?.estado ?? '';
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isSaving = true);

    // Creamos la instancia genérica de T (Necesitas un constructor adecuado)
    // Nota: La creación real de T debe hacerse a través del constructor específico en el onSave.

    // Para simplificar, usaremos un Map temporal y confiaremos en que onSave cree la instancia:
    final Map<String, dynamic> data = {
      'id': widget.item?.id,
      'nombre': _nombre,
      'estado': _estado,
    };

    // Creamos una instancia de ReferenciaBase temporal para pasar los datos.
    final itemToSave = ReferenciaBase(
      id: data['id'] ?? '',
      nombre: data['nombre'],
      estado: data['estado'],
    );

    try {
      // Delegamos la creación de la instancia específica al Provider.
      await widget.onSave(itemToSave as T);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item == null
              ? 'Nuevo ${widget.title}'
              : 'Editar ${widget.title}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(
                  labelText: 'Nombre de ${widget.title}',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un nombre.';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 30),
              ActionButton(
                text: widget.item == null ? 'Registrar' : 'Guardar Cambios',
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
