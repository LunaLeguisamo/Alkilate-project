import requests
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

url = 'https://app-p7vfglazhq-uc.a.run.app/products'

response = requests.get(url)

if response.status_code == 200:
    products = response.json()
else:
    print(f'Error: {response.status_code}')
    products = []

def suggestions(products, query, top_n=2):
    # Crear una lista de descripciones combinando nombre y categoría
    query_s = [f"{product['name']} {product['category']} {product['description']}" for product in products]
    
    # Añadir la consulta del usuario a las descripciones
    query_s.append(query)
    
    # Vectorizar las descripciones utilizando TF-IDF
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(query_s)
    
    # Calcular la similitud de coseno entre la consulta y las descripciones
    similitudes = cosine_similarity(tfidf_matrix[-1], tfidf_matrix[:-1]).flatten()
    
    # Obtener los índices de los productos con mayor similitud
    index = np.argsort(similitudes)[::-1][:top_n]
    
    # Retornar los productos recomendados
    p_suggestion = [products[i] for i in index]
    return p_suggestion

# Ejemplo de uso
query = 'I wanna do sport'
p_suggestion = suggestions(products, query)

print('Suggestions:')
for product in p_suggestion:
    print(product['name'])
