// lib/models/tarea.dart
// Utiliza IDs para referencias N:1 y N:M

class Tarea {
  String? id;
  String idTipoTarea; // Foreign Key: TipoTarea
  String nombre;
  String descripcion;
  String idCultivo; // Foreign Key: Cultivo
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado;

  // Relaciones N:M almacenadas como listas de IDs
  List<String> idAgricultores; // (Tabla TareaAgricultor)
  List<String> idInsumos; // (Tabla TareaInsumo)

  Tarea({
    this.id,
    required this.idTipoTarea,
    required this.nombre,
    required this.descripcion,
    required this.idCultivo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.idAgricultores,
    required this.idInsumos,
  });

  // Convierte Map (JSON de la API) a objeto Tarea
  factory Tarea.fromMap(Map<String, dynamic> data) {
    return Tarea(
      id: data['id'] as String?,
      idTipoTarea: data['idTipoTarea'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      idCultivo: data['idCultivo'] as String? ?? '',
      fechaInicio: DateTime.parse(data['fechaInicio'] as String),
      fechaFin: DateTime.parse(data['fechaFin'] as String),
      estado: data['estado'] as String? ?? 'Pendiente',
      idAgricultores: List<String>.from(data['idAgricultores'] ?? []),
      idInsumos: List<String>.from(data['idInsumos'] ?? []),
    );
  }

  // Convierte objeto Tarea a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'idTipoTarea': idTipoTarea,
      'nombre': nombre,
      'descripcion': descripcion,
      'idCultivo': idCultivo,
      'fechaInicio': fechaInicio.toIso8601String().split('T').first,
      'fechaFin': fechaFin.toIso8601String().split('T').first,
      'estado': estado,
      'idAgricultores': idAgricultores,
      'idInsumos': idInsumos,
    };
  }
}
