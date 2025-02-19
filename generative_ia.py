from flask import Flask, request, jsonify
import vertexai
from vertexai.language_models import TextGenerationModel
from google.oauth2 import service_account
from google.cloud import firestore
import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate("path/to/serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.Client(credentials=cred, project="Alkilate-Project")

# Inicializar Vertex AI
vertexai.init(
    project="Alkilate-Project",
    location="southamerica-east1",
    credentials=cred,
)

# Función para obtener productos de Firestore
def get_products():
    productos_ref = db.collection("Products").stream()
    productos = [{"nombre": p.get("nombre"), "descripcion": p.get("descripcion")} for p in productos_ref]
    return productos

# Función para generar sugerencias con Gemini
def suggest_products(user_query):
    products = get_products()
    product_texts = "\n".join([f"{p['nombre']}: {p['descripcion']}" for p in products])

    prompt = f"""
    Tenemos estos productos disponibles:
    {product_texts}

    Basado en estos productos, sugiere los más relevantes para la consulta: "{user_query}"
    """

    model = TextGenerationModel.from_pretrained("gemini-2.0-flash")
    response = model.predict(prompt)

    return response.text.split("\n")  # Convertir a lista

# Crear API con Flask
app = Flask(__name__)

@app.route("/api/ia", methods=["POST"])
def get_suggestions():
    data = request.json
    user_query = data.get("consulta", "")

    if not user_query:
        return jsonify({"error": "Falta la consulta"}), 400

    suggestions = suggest_products(user_query)
    return jsonify({"sugerencias": suggestions})

if __name__ == "__main__":
    app.run(host="10.0.2.2", port=5000, debug=True)
