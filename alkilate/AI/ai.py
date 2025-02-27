from sentence_transformers import SentenceTransformer, util
import numpy as np
import requests

model = SentenceTransformer('all-MiniLM-L6-v2')

url = 'https://app-p7vfglazhq-uc.a.run.app/products'
response = requests.get(url)

if response.status_code == 200:
    products = response.json()
    print(f'Loaded products: {[product["name"] for product in products]}')

else:
    print(f'Error loading products: {response.status_code}')
    products = []

def suggestions(products, query, top_n=10):
    info = [f"{product['name']} {product['category']}" for product in products]
    vectors_info = model.encode(info, convert_to_tensor=True)
    vectors_query = model.encode(query, convert_to_tensor=True)
    
    similarities = util.pytorch_cos_sim(vectors_query, vectors_info)[0].cpu().numpy()
    
    similar_indices = np.argsort(similarities)[::-1][:top_n]
    
    umbral = 0.2
    
    suggested_products = [products[i] for i in similar_indices if similarities[i] > umbral]
    return suggested_products

query = "tool"
suggested_products = suggestions(products, query, 10)

if suggested_products:
    print('Suggestions:')
    for product in suggested_products:
        print(product['name'])
else:
    print('No suggestions found')
    
