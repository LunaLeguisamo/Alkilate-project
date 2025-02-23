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
    if not products:
        print('No products availables for suggestions')
        
    query_s = [f"{product['name']} {product['category']} {product['description']}" for product in products]
    
    query_s.append(query)
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(query_s)
    
    similitudes = cosine_similarity(tfidf_matrix[-1], tfidf_matrix[:-1]).flatten()
    
    # Obtener los índices de los productos con mayor similitud en orden descendente
    index = np.argsort(similitudes)[::-1][:top_n]
    
    p_suggestion = [products[i] for i in index]
    return p_suggestion

    if len(p_suggestion) > top_n:
        print("Not found enought suggestions")

query = 'saw'
p_suggestion = suggestions(products, query)

if p_suggestion:
    print('Suggestions:')
    for product in p_suggestion:
        print(product['name'], product['id'])
else:
    print('No suggestions found')
    
