import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool isDecimal;
  final Function(String) onSaved;

  const NumericInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.isDecimal = false,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: isDecimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        inputFormatters: [
          if (isDecimal)
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          if (!isDecimal) FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: (value) => onSaved(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese un valor para $label';
          }
          final numValue = isDecimal
              ? double.tryParse(value)
              : int.tryParse(value);
          if (numValue == null || numValue < 0) {
            return 'El valor debe ser un número positivo.';
          }
          return null;
        },
      ),
    );
  }
}
