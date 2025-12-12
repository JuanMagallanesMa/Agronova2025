// lib/models/tarea.dart

import '../core/app_constants.dart';
import 'insumo_agregado.dart';

class Tarea {
  String? id;
  String idTipoTarea; // Foreign Key: TipoTarea
  String nombre;
  String descripcion;
  String idCultivo; // Foreign Key: Cultivo
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado;

  List<String> idAgricultores; // (Tabla TareaAgricultor)
  
  // 2. Reemplazar idInsumos
  List<InsumoAsignado> insumosAsignados; // (Tabla TareaInsumo con cantidad)

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
    required this.insumosAsignados, // 3. Actualizar constructor
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
      estado: data['estado'] as String? ?? AppStatus.pendiente,
      idAgricultores: List<String>.from(data['idAgricultores'] ?? []),
      
      // 4. Mapear la lista de objetos anidada
      insumosAsignados: (data['insumosAsignados'] as List<dynamic>? ?? [])
          .map((item) => InsumoAsignado.fromMap(item as Map<String, dynamic>))
          .toList(),
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
      
      // 5. Serializar la lista de objetos
      'insumosAsignados': insumosAsignados.map((item) => item.toMap()).toList(),
    };
  }

  // 6. El método toUpdateCompleteMap debe replicar el cambio
  Map<String, dynamic> toUpdateCompleteMap() {
    return {
      'idTipoTarea': idTipoTarea,
      'nombre': nombre,
      'descripcion': descripcion,
      'idCultivo': idCultivo,
      'fechaInicio': fechaInicio.toIso8601String().split('T').first,
      'fechaFin': fechaFin.toIso8601String().split('T').first,
      'estado': AppStatus.completada,
      'idAgricultores': idAgricultores,
      'insumosAsignados': insumosAsignados.map((item) => item.toMap()).toList(),
    };
  }

  // 7. Actualizar el copyWith
  Tarea copyWith({
    String? id,
    String? idTipoTarea,
    String? nombre,
    String? descripcion,
    String? idCultivo,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? estado,
    List<String>? idAgricultores,
    List<InsumoAsignado>? insumosAsignados, // 8. Actualizar tipo
  }) {
    return Tarea(
      id: id ?? this.id,
      idTipoTarea: idTipoTarea ?? this.idTipoTarea,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      idCultivo: idCultivo ?? this.idCultivo,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      idAgricultores: idAgricultores ?? this.idAgricultores,
      insumosAsignados: insumosAsignados ?? this.insumosAsignados, // 9. Actualizar asignación
    );
  }
}