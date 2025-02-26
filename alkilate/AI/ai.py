from sentence_transformers import SentenceTransformer, util
import numpy as np
import requests

# Cargar modelo SBERT
model = SentenceTransformer('all-MiniLM-L6-v2')

# Fetch products from the API
"""
url = 'https://app-p7vfglazhq-uc.a.run.app/products'
response = requests.get(url)

if response.status_code == 200:
    products = response.json()
    print(f'Loaded products: {[product["name"] for product in products]}')
    print(f'Loaded products: {[product["category"] for product in products]}')
    print(f'Loaded products: {[product["description"] for product in products]}')

else:
    print(f'Error loading products: {response.status_code}')
    products = []
"""

products = [
    {"name": "Running Shoes", "category": "Sports", "description": "Lightweight running shoes for maximum performance."},
    {"name": "Yoga Shoes", "category": "Clothes", "description": "Yoga shoes for maximum relaxing."},
    {"name": "Yoga Shoes", "category": "Clothes", "description": "Cute barbie shoes for go out."},
    {"name": "Basketball", "category": "Sports", "description": "Official size basketball for indoor and outdoor games."},
    {"name": "Yoga Mat", "category": "Fitness", "description": "Non-slip yoga mat with extra cushioning for comfort."},
    {"name": "Dumbbells Set", "category": "Fitness", "description": "Adjustable dumbbells for home gym workouts."},
    {"name": "Mountain Bike", "category": "Sports", "description": "Durable mountain bike with shock absorbers."},
    {"name": "Tennis Racket", "category": "Sports", "description": "Lightweight tennis racket for professional and beginner players."},
    {"name": "Protein Powder", "category": "Nutrition", "description": "High-quality protein powder for muscle recovery."},
    {"name": "Football", "category": "Sports", "description": "Standard size football for training and matches."},
    {"name": "Boxing Gloves", "category": "Sports", "description": "Durable leather boxing gloves for professional training."},
    {"name": "Smartwatch", "category": "Electronics", "description": "Fitness smartwatch with heart rate monitor and GPS tracking."},
    {"name": "Resistance Bands", "category": "Fitness", "description": "Elastic resistance bands for full-body workouts."},
    {"name": "Hiking Backpack", "category": "Outdoors", "description": "Waterproof hiking backpack with multiple compartments."},
    {"name": "Skateboard", "category": "Sports", "description": "Professional skateboard for tricks and street skating."},
    {"name": "Treadmill", "category": "Fitness", "description": "High-performance treadmill with speed adjustment."},
    {"name": "Cycling Helmet", "category": "Safety", "description": "Protective helmet for safe cycling."},
    {"name": "Laptop", "category": "Electronic", "description": "A portatil computer."},
    {"name": "Birthday Cake", "category": "Party", "description": "Delicious customizable birthday cake with various flavors."},
    {"name": "Party Balloons", "category": "Decor", "description": "Colorful and festive balloons to decorate any birthday party."},
    {"name": "Birthday Party Hats", "category": "Accessories", "description": "Fun, vibrant party hats perfect for birthday celebrations."},
    {"name": "Gift Cards", "category": "Gifts", "description": "Versatile gift cards for a personalized birthday gift."},
    {"name": "Birthday Candles", "category": "Decor", "description": "Sparkling candles to top off your birthday cake."},
    {"name": "Party Decorations", "category": "Decor", "description": "Themed decorations to create a fun and festive birthday atmosphere."},
    {"name": "Gift Baskets", "category": "Gifts", "description": "Beautifully arranged gift baskets filled with treats for birthdays."}
]

def suggestions(products, query, top_n=10):
    info = [f"{product['name']} {product['category']} {product['description']}" for product in products]
    
    vectors_info = model.encode(info, convert_to_tensor=True)
    vectos_query = model.encode(query, convert_to_tensor=True)
    print(vectors_info)
    
    similarities = util.pytorch_cos_sim(vectos_query, vectors_info)[0].cpu().numpy()
    print(similarities)
    
    similar_indices = np.argsort(similarities)[::-1][:top_n]
    
    umbral = 0.2
    
    suggested_products = [products[i] for i in similar_indices if similarities[i] > umbral]
    return suggested_products

query = "I will make a birthday"
suggested_products = suggestions(products, query, 10)

if suggested_products:
    print('Suggestions:')
    for product in suggested_products:
        print(product['name'])
else:
    print('No suggestions found')