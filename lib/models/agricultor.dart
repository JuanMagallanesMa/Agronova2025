class Agricultor {
  String? id;
  String nombre;
  int? edad;
  String zona;
  String experiencia;
  String? estado;

  Agricultor({
    this.id,
    required this.nombre,
    this.edad,
    required this.zona,
    required this.experiencia,
    this.estado,
  });

  // Convierte Map (JSON de la API) a objeto Agricultor
  factory Agricultor.fromMap(Map<String, dynamic> data) {
    return Agricultor(
      id: data['id'] as String?,
      nombre: data['nombre'] as String? ?? '',
      edad: (data['edad'] as num?)?.toInt(),
      zona: data['zona'] as String? ?? '',
      experiencia: data['experiencia'] as String? ?? '',
      estado: data['estado'] as String?,
    );
  }

  // Convierte objeto Agricultor a Map (JSON para la API)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'edad': edad,
      'zona': zona,
      'experiencia': experiencia,
      if (estado != null) 'estado': estado,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Agricultor && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
