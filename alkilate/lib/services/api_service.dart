import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductSuggestionPage extends StatefulWidget {
  const ProductSuggestionPage({super.key});

  @override
  ProductSuggestionPageState createState() => ProductSuggestionPageState();
}

class ProductSuggestionPageState extends State<ProductSuggestionPage> {
  TextEditingController queryController = TextEditingController();
  List<String> suggestions = [];

  Future<void> getSuggestions(String query) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/sugerencias"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"consulta": query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        suggestions = List<String>.from(data['sugerencias']);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sugerencias de Productos')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: queryController,
              decoration: InputDecoration(
                labelText: '¿Qué necesitas?',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getSuggestions(queryController.text);
              },
              child: Text('"Buscar"'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
