class MensajeChat {
  final String contenido;
  final bool esUsuario; // true = Agricultor, false = IA
  final DateTime fecha;

  MensajeChat({
    required this.contenido,
    required this.esUsuario,
    required this.fecha,
  });
}
