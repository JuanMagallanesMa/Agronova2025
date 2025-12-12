import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/providers/ia_provider.dart';
import 'package:agronova_app/providers/agricultor_provider.dart';

class BotonComandoVoz extends StatefulWidget {
  const BotonComandoVoz({super.key});

  @override
  State<BotonComandoVoz> createState() => _BotonComandoVozState();
}

class _BotonComandoVozState extends State<BotonComandoVoz>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _escuchar() async {
    if (!_isListening) {
      // Pedir permisos primero
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;

      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            if (val.finalResult) {
              setState(() => _isListening = false);
              _procesarTexto(val.recognizedWords);
            }
          },
          localeId: 'es_ES',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _procesarTexto(String texto) async {
    if (texto.isEmpty) return;

    final idUser = context.read<AgricultorProvider>().agricultorActual?.id;
    if (idUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No hay usuario logueado")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🧠 Procesando: '$texto'"),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    final resultado = await context.read<IaProvider>().enviarComandoVoz(
      texto,
      idUser,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado['mensaje']),
          backgroundColor: resultado['exito'] ? Colors.green : Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'mic_btn',
      onPressed: _escuchar,
      backgroundColor: _isListening ? Colors.redAccent : Colors.green,
      child: _isListening
          ? ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.2).animate(_animController),
              child: const Icon(Icons.mic, size: 30),
            )
          : const Icon(Icons.mic_none, size: 30),
    );
  }
}
