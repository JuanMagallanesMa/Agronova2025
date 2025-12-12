import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agronova_app/core/app_constants.dart'; // Donde tengas tu URL base

class IaApi {
  final String baseUrl = AppConstants.apiBaseUrl;

  // 1. Chat Normal
  Future<String> consultarAsistente(String pregunta) async {
    final url = Uri.parse('$baseUrl/v1/ia/consultar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pregunta': pregunta}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['respuesta'];
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  // 2. Comandos de Voz
  Future<Map<String, dynamic>> enviarComandoVoz(
    String texto,
    String idAgricultor,
  ) async {
    final url = Uri.parse('$baseUrl/v1/ia/comando');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'texto': texto, 'idAgricultor': idAgricultor}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {
        'exito': false,
        'mensaje': 'Error del servidor: ${response.statusCode}',
      };
    }
  }
}
