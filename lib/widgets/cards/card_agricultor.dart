import 'package:flutter/material.dart';
import 'package:agronova_app/models/agricultor.dart';

class CardAgricultor extends StatelessWidget {
  final Agricultor agricultor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardAgricultor({
    super.key,
    required this.agricultor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.person, color: Colors.green),
        ),
        title: Text(
          agricultor.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zona: ${agricultor.zona}'),
            Text('Edad: ${agricultor.edad ?? 'N/A'}'),
            Text('Experiencia: ${agricultor.experiencia}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
