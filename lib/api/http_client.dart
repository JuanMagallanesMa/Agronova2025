// lib/api/http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// URL BASE DE TU API. ¡DEBES REEMPLAZAR ESTA URL POR LA REAL DE TU BACKEND!
const String _kBaseUrl = 'http://10.0.2.2:3000/v1';

class HttpClient {
  static const Map<String, String> kHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET ALL: Obtener una lista de entidades
  Future<List<Map<String, dynamic>>> fetchList(String endpoint) async {
    final uri = Uri.parse('$_kBaseUrl$endpoint');

    debugPrint('--- [FRONT-END] Enviando GET ---');
    debugPrint('URL: $uri');

    final response = await http.get(uri, headers: kHeaders);
    // --- LOG DE RESPUESTA ---
    debugPrint('--- [FRONT-END] Respuesta Recibida (GET) ---');
    debugPrint('URL: $uri');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');
    // ------------------------

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      debugPrint('Error GET $endpoint: ${response.statusCode}');
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }
  }

  // POST: Crear una nueva entidad
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_kBaseUrl$endpoint');
    final body = json.encode(data);
    // --- LOG ANTES DE ENVIAR ---
    debugPrint('--- [FRONT-END] Enviando POST ---');
    debugPrint('URL: $uri');
    debugPrint('BODY Enviado: $body');
    // ---------------------------
    final response = await http.post(
      uri,
      headers: kHeaders,
      body: json.encode(data),
    );

    // --- LOG DE RESPUESTA ---
    debugPrint('--- [FRONT-END] Respuesta Recibida (POST) ---');
    debugPrint('URL: $uri');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY Recibido: ${response.body}');
    // ------------------------

    if (response.statusCode == 201) {
      // 201: Created
      return json.decode(response.body);
    } else {
      debugPrint(
        'Error POST $endpoint: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al crear entidad: ${response.statusCode}');
    }
  }

  // PUT: Actualizar una entidad existente (uso interno por ReferenciaApi)
  Future<void> put(
    String endpoint,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_kBaseUrl$endpoint/$id');
    final body = json.encode(data);

    // --- LOG ANTES DE ENVIAR ---
    debugPrint('--- [FRONT-END] Enviando PUT ---');
    debugPrint('URL: $uri');
    debugPrint('BODY Enviado: $body');
    // ---------------------------

    final response = await http.put(
      uri,
      headers: kHeaders,
      body: json.encode(data),
    );

    // --- LOG DE RESPUESTA ---
    debugPrint('--- [FRONT-END] Respuesta Recibida (PUT) ---');
    debugPrint('URL: $uri');
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('BODY Recibido: ${response.body}');
    // ------------------------

    if (response.statusCode != 200) {
      debugPrint(
        'Error PUT $endpoint/$id: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al actualizar entidad: ${response.statusCode}');
    }
  }

  Future<void> delete(String endpoint, String id) async {
    final uri = Uri.parse('$_kBaseUrl$endpoint/$id');

    debugPrint('--- [FRONT-END] Enviando DELETE ---');
    debugPrint('URL: $uri');

    final response = await http.delete(uri, headers: kHeaders);

    debugPrint('--- [FRONT-END] Respuesta Recibida (DELETE) ---');
    debugPrint('URL: $uri');
    debugPrint('STATUS CODE: ${response.statusCode}');

    // 204: No Content (Éxito para DELETE)
    if (response.statusCode != 204) {
      debugPrint(
        'Error DELETE $endpoint/$id: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Error al eliminar entidad: ${response.statusCode}');
    }
  }
}
