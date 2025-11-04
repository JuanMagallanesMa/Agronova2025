import 'package:flutter/material.dart';
import 'package:agronova_app/models/venta.dart';
import 'package:agronova_app/core/app_constants.dart';
import 'package:intl/intl.dart';

class CardVenta extends StatelessWidget {
  final Venta venta;
  final VoidCallback onAnular;
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
  );
  CardVenta({super.key, required this.venta, required this.onAnular});

  @override
  Widget build(BuildContext context) {
    final isAnulada = venta.estado == AppStatus.anulada;
    final statusColor = isAnulada ? Colors.red : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          child: Icon(Icons.receipt_long, color: statusColor),
        ),
        title: Text(
          'Cliente: ${venta.nombreCliente}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusColor,
            decoration: isAnulada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: ${currencyFormat.format(venta.total)}'),
            Text('Estado: ${venta.estado}'),
            Text('Productos: ${venta.detalles.length} items'),
          ],
        ),
        trailing: isAnulada
            ? const Icon(Icons.block, color: Colors.red)
            : IconButton(
                icon: const Icon(Icons.cancel, color: Colors.orange),
                onPressed: onAnular,
                tooltip: 'Anular Venta',
              ),
      ),
    );
  }
}
