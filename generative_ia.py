from google import genai
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:firebase_core/firebase_core.dart';
import vertexai

vertexai.init(
        project=Alkaid-Project,
        location=Montevideo, Uruguay,
        experiment=experiment,
        staging_bucket=staging_bucket,
        credentials=credentials,
        encryption_spec_key_name=encryption_spec_key_name,
        service_account=service_account,
    )

client = genai.Client(api_key="AIzaSyDDXqEw67La5mkxK-Yy53q0nUhJIunZwow")
response = client.models.generate_content(
    model="gemini-2.0-flash", contents="Explain how AI works"
)
print(response.text)


await Firebase.initializeApp();
// Initialize the Vertex AI service and the generative model.
final model =
      FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-2.0-flash',
        // In the generation config, set the `responseMimeType` to `application/json`
        // and pass the JSON schema object into `responseSchema`.
        generationConfig: GenerationConfig(
            responseMimeType: 'application/json', responseSchema: jsonSchema));
