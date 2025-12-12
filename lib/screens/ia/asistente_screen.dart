import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:agronova_app/providers/ia_provider.dart';
import 'package:agronova_app/models/mensaje_chat.dart';

class AsistenteScreen extends StatelessWidget {
  static const String routeName = '/asistente';
  final TextEditingController _controller = TextEditingController();

  AsistenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Agronova 🤖'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: () => context.read<IaProvider>().limpiarChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<IaProvider>(
              builder: (ctx, provider, _) {
                if (provider.mensajes.isEmpty) {
                  return const Center(
                    child: Text(
                      "Pregúntame sobre tus cultivos...",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: provider.mensajes.length,
                  itemBuilder: (ctx, i) =>
                      _MensajeBubble(msg: provider.mensajes[i]),
                );
              },
            ),
          ),
          if (context.watch<IaProvider>().cargando)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe tu duda...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  child: const Icon(Icons.send),
                  onPressed: () {
                    context.read<IaProvider>().enviarPregunta(_controller.text);
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeBubble extends StatelessWidget {
  final MensajeChat msg;
  const _MensajeBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final esMio = msg.esUsuario;
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: esMio ? Colors.green[100] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: esMio
            ? Text(msg.contenido)
            : MarkdownBody(
                data: msg.contenido,
              ), // Renderiza negritas y listas de la IA
      ),
    );
  }
}
