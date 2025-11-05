// lib/models/venta_detalle.dart
// (o donde tengas tus modelos)

class VentaDetalle {
  final String idProducto;
  final String nombreProducto; // Útil para el UI
  final double precioUnitario; // Coincide con DTO
  final int cantidad;
  final double subtotal; // Coincide con DTO

  // Constructor principal: Usado al crear/modificar en el UI
  // Calcula el subtotal automáticamente
  VentaDetalle({
    required this.idProducto,
    required this.nombreProducto,
    required this.precioUnitario,
    required this.cantidad,
  }) : subtotal = precioUnitario * cantidad;

  // Constructor privado: Usado por fromMap para asignar el subtotal de la API
  VentaDetalle._({
    required this.idProducto,
    required this.nombreProducto,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
  });

  // Convierte Map (JSON de API) a objeto VentaDetalle
  // Usado al LEER datos de la API (GET)
  factory VentaDetalle.fromMap(Map<String, dynamic> data) {
    return VentaDetalle._(
      idProducto: data['idProducto'] as String? ?? '',
      nombreProducto:
          data['nombreProducto'] as String? ??
          '', // API no lo envía, pero útil si lo agregas
      precioUnitario: (data['precioUnitario'] as num?)?.toDouble() ?? 0.0,
      cantidad: (data['cantidad'] as num?)?.toInt() ?? 0,
      subtotal:
          (data['subtotal'] as num?)?.toDouble() ??
          0.0, // Lee el subtotal de la API
    );
  }

  // Convierte objeto VentaDetalle a Map (JSON para la API)
  // Usado al CREAR/ACTUALIZAR datos (POST, PUT)
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
      // 'nombreProducto' se omite, el DTO no lo espera
    };
  }

  // copyWith para actualizar la cantidad/precio en el formulario
  VentaDetalle copyWith({
    String? idProducto,
    String? nombreProducto,
    double? precioUnitario, // <-- CORREGIDO (antes precioCaja)
    int? cantidad,
  }) {
    // Usa el constructor principal para que el subtotal se recalcule
    return VentaDetalle(
      idProducto: idProducto ?? this.idProducto,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precioUnitario: precioUnitario ?? this.precioUnitario, // <-- CORREGIDO
      cantidad: cantidad ?? this.cantidad,
    );
  }
}
