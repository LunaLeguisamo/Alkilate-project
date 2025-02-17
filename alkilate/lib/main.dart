import 'package:flutter/material.dart';
import 'package:alkilate/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'firebase_options.dart';

from google import genai

client = genai.Client(api_key="YOUR_API_KEY")
response = client.models.generate_content(
    model="gemini-2.0-flash", contents="Explain how AI works"
)
print(response.text)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAFBtibNSl0G0BNHpkELKJsCqGtAHe76GE',
      appId: '1:94687048095:android:9aa3e9805df6bb756bcdaa',
      messagingSenderId: '94687048095',
      projectId: 'alkilate-a4fbc',
      storageBucket: 'alkilate-a4fbc.firebasestorage.app',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              routes: appRoutes,
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

final model =
  FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-pro');

// Provide a prompt that contains text
final prompt = [Content.text('Write a theme for see products')];

// To generate text output, call generateContent with the text input
final response = await model.generateContent(prompt);
print(response.text);