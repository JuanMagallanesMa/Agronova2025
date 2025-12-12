// Constantes para estados de eliminación o anulación lógica
class AppStatus {
  static const String activo = 'Activo';
  static const String inactivo = 'Inactivo'; // Usado para eliminación lógica
  static const String pendiente = 'Pendiente';
  static const String completada = 'Completada';
  static const String anulada = 'Anulada'; // Usado para anular una Venta
}

class AppConstants {
  // Ajusta esta URL según tu entorno:
  // - Android Emulador: 'http://10.0.2.2:3000'
  // - Dispositivo Físico / iOS: 'http://TU_IP_LOCAL:3000' (ej: 192.168.1.50:3000)
  static const String apiBaseUrl = 'http://10.0.2.2:3000';
}
