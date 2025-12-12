import 'package:flutter/material.dart';
import 'package:agronova_app/api/ia_api.dart'; // Asegúrate de haber creado este archivo API
import 'package:agronova_app/models/mensaje_chat.dart'; // Modelo para el chat

class IaProvider with ChangeNotifier {
  final IaApi _api = IaApi();

  // --- ESTADO DEL CHAT ---
  final List<MensajeChat> _mensajes = [];
  bool _cargando = false;
  
  // --- ESTADO DE VOZ ---
  bool _procesandoVoz = false;

  // Getters para usar en la UI
  List<MensajeChat> get mensajes => _mensajes;
  bool get cargando => _cargando;
  bool get procesandoVoz => _procesandoVoz;

  // -----------------------------------------------------
  // MÉTODO 1: CHAT DE TEXTO (Preguntas y Respuestas)
  // -----------------------------------------------------
  Future<void> enviarPregunta(String texto) async {
    if (texto.trim().isEmpty) return;

    // 1. Agregar mensaje del usuario a la lista visual inmediatamente
    _mensajes.add(MensajeChat(
      contenido: texto,
      esUsuario: true,
      fecha: DateTime.now(),
    ));
    _cargando = true;
    notifyListeners(); // Actualiza la pantalla para mostrar "Escribiendo..."

    try {
      // 2. Consultar al Backend
      final respuestaIa = await _api.consultarAsistente(texto);

      // 3. Agregar respuesta de la IA
      _mensajes.add(MensajeChat(
        contenido: respuestaIa,
        esUsuario: false,
        fecha: DateTime.now(),
      ));
    } catch (e) {
      // Manejo de error en el chat
      _mensajes.add(MensajeChat(
        contenido: "⚠️ Error de conexión: No pude contactar al agrónomo virtual.",
        esUsuario: false,
        fecha: DateTime.now(),
      ));
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------
  // MÉTODO 2: COMANDO DE VOZ (Acciones Reales)
  // -----------------------------------------------------
  Future<Map<String, dynamic>> enviarComandoVoz(String texto, String idAgricultor) async {
    _procesandoVoz = true;
    notifyListeners(); // Pone el botón de micrófono en estado "pensando"

    try {
      // Llamamos a la API especializada en comandos
      final respuesta = await _api.enviarComandoVoz(texto, idAgricultor);
      
      return respuesta; // Devuelve { exito: true, mensaje: "Tarea creada" }

    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'Error de conexión: $e'
      };
    } finally {
      _procesandoVoz = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------
  // UTILIDADES
  // -----------------------------------------------------
  void limpiarChat() {
    _mensajes.clear();
    notifyListeners();
  }
}