import 'package:flutter/material.dart';
import 'package:agronova_app/models/referencia_base.dart';

class FormDropdownCatalogo<T extends ReferenciaBase> extends StatelessWidget {
  final String label;
  final String selectedId;
  final List<T> items;
  final Function(String?) onChanged;

  const FormDropdownCatalogo({
    super.key,
    required this.label,
    required this.selectedId,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // El valor debe ser String (el ID) o null.
    final String? currentValue = selectedId.isEmpty ? null : selectedId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: currentValue,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item.id,
            child: Text(item.nombre),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Seleccione una opción de $label';
          }
          return null;
        },
      ),
    );
  }
}
