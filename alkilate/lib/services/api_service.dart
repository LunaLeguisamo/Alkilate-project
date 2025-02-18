import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // Función para obtener sugerencias desde la API
  static Future<List<String>> fetchSuggestions(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sugerencias'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'consulta': query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['sugerencias']);
      } else {
        throw Exception('Error en la solicitud: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
