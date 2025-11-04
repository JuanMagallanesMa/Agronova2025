import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateInputField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: selectedDate == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(selectedDate!),
        ),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
        validator: (value) {
          if (selectedDate == null) {
            return 'Seleccione una fecha de $label';
          }
          return null;
        },
      ),
    );
  }
}
