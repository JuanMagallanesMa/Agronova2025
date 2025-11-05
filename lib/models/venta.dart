// lib/models/venta.dart
// (o donde tengas tus modelos)

import 'venta_detalle.dart'; // Asegúrate que la ruta sea correcta

class Venta {
  String? id;
  String nombreCliente; // Para el UI
  String cedula; // Para el UI
  double total;
  String? estado;
  List<VentaDetalle> detalles;
  DateTime fecha; // <-- AÑADIDO: Requerido por el DTO

  Venta({
    this.id,
    required this.nombreCliente,
    required this.cedula,
    required this.total,
    this.estado,
    required this.detalles,
    required this.fecha, // <-- AÑADIDO
  });

  // Convierte Map (JSON de la API) a objeto Venta
  // Usado al LEER datos de la API (GET)
  factory Venta.fromMap(Map<String, dynamic> data) {
    final List<dynamic> rawDetalles = data['detalles'] ?? [];

    // El API devuelve 'cliente', no 'nombreCliente' ni 'cedula'
    String clienteFromApi = data['cliente'] as String? ?? '';
    // Aquí puedes decidir cómo manejar el string 'cliente'
    // Por simplicidad, lo asignamos a nombreCliente

    return Venta(
      id: data['id'] as String?,
      nombreCliente: clienteFromApi, // <-- AJUSTADO
      cedula: '', // <-- AJUSTADO (La API no lo devuelve por separado)
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      estado: data['estado'] as String?,
      // Parsea la fecha de la API, con un fallback
      fecha:
          DateTime.tryParse(data['fecha'] ?? '') ??
          DateTime.now(), // <-- AÑADIDO
      detalles: rawDetalles.map((d) => VentaDetalle.fromMap(d)).toList(),
    );
  }

  // Convierte objeto Venta a Map (JSON para la API)
  // Usado al CREAR datos (POST)
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha
          .toIso8601String(), // <-- AÑADIDO (Formato YYYY-MM-DDTHH:mm:ssZ)
      'cliente':
          '$nombreCliente - $cedula', // <-- AJUSTADO (Unifica los campos)
      'total': total,
      'detalles': detalles.map((d) => d.toMap()).toList(),
      // No se envían 'id', 'estado', 'nombreCliente', 'cedula' por separado
    };
  }
}
