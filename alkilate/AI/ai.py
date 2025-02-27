from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer, util
import numpy as np
import requests

app = Flask(__name__)

model = SentenceTransformer('all-MiniLM-L6-v2')

url = 'https://app-p7vfglazhq-uc.a.run.app/products'
response = requests.get(url)

if response.status_code == 200:
    products = response.json()
    print(f'Productos cargados: {[product["name"] for product in products]}')
else:
    print(f'Error al cargar los productos: {response.status_code}')
    products = []

def suggestions(products, query, top_n=10):
    info = [f"{product['name']} {product['category']} {product['description']}" for product in products]
    vectors_info = model.encode(info, convert_to_tensor=True)
    vectors_query = model.encode(query, convert_to_tensor=True)
    
    similarities = util.pytorch_cos_sim(vectors_query, vectors_info)[0].cpu().numpy()
    
    similar_indices = np.argsort(similarities)[::-1][:top_n]
    
    umbral = 0.1
    
    suggested_products = [products[i] for i in similar_indices if similarities[i] > umbral]
    return suggested_products

@app.route('/suggestions', methods=['POST'])
def get_suggestions():
    data = request.get_json()
    query = data.get('query', '')
    if not query:
        return jsonify({'error': 'No query provided'}), 400
    
    suggested_products = suggestions(products, query)
    return jsonify(suggested_products)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
