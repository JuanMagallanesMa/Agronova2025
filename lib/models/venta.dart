import 'venta_detalle.dart';

class Venta {
  String? id;
  String nombreCliente;
  String cedula;
  double total;
  String? estado;
  List<VentaDetalle> detalles; // Lista de VentaDetalle

  Venta({
    this.id,
    required this.nombreCliente,
    required this.cedula,
    required this.total,
    this.estado,
    required this.detalles,
  });

  // Convierte Map (JSON de la API) a objeto Venta
  factory Venta.fromMap(Map<String, dynamic> data) {
    final List<dynamic> rawDetalles = data['detalles'] ?? [];
    return Venta(
      id: data['id'] as String?,
      nombreCliente: data['nombreCliente'] as String? ?? '',
      cedula: data['cedula'] as String? ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      estado: data['estado'] as String?,
      detalles: rawDetalles.map((d) => VentaDetalle.fromMap(d)).toList(),
    );
  }

  // Convierte objeto Venta a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombreCliente': nombreCliente,
      'cedula': cedula,
      'total': total,
      if (estado != null) 'estado': estado,
      'detalles': detalles.map((d) => d.toMap()).toList(),
    };
  }
}
