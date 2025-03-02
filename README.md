# Alkilate  
**Peer-to-Peer Rental Marketplace**

![alkilate](https://github.com/user-attachments/assets/b0ce2869-1855-4950-a4c1-ed8816ff5e17)

# Table of Contents
1. [Alkilate - Peer-to-Peer Rental Marketplace](#alkilate---peer-to-peer-rental-marketplace)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [Installation](#installation)
   - 4.1 [Prerequisites](#prerequisites)
   - 4.2 [Steps](#steps)
5. [Usage](#usage)
   - 5.1 [For Renters](#for-renters)
   - 5.2 [For Owners](#for-owners)
6. [Project Structure](#project-structure)
7. [Alkilate API Documentation](#alkilate-api-documentation)
   - 7.1 [Base URL](#base-url)
   - 7.2 [Authentication](#authentication)
   - 7.3 [Endpoints](#endpoints)
     - 7.3.1 [Test Endpoint](#test-endpoint)
     - 7.3.2 [Admin Endpoints](#admin-endpoints)
     - 7.3.3 [Payment Endpoints](#payment-endpoints)
   - 7.4 [Error Handling](#error-handling)
   - 7.5 [Product Suggestions API](#product-suggestions-api)


Alkilate is a modern mobile application that connects people who want to rent out their items with those who need them temporarily. Built with Flutter and Firebase, this platform enables users to list products, manage availability with a calendar system, and process rental orders seamlessly.

---

## Features  
- **User Authentication**: Secure sign-up and login functionality  
- **Product Listings**: Browse, search, and filter available rental items  
- **Calendar Integration**: Dynamic availability calendar for rental products  
- **Location Services**: Map integration to show pickup locations  
- **Order Management**: Complete rental order processing system  
- **Admin Dashboard**: Moderation tools for approving/rejecting listings  
- **Responsive Design**: Works on Android  

---

## Technologies Used  
- **Frontend**: Flutter/Dart  
- **Backend**: Firebase (Firestore, Authentication, firefunction api)  
- **Maps**: Google Maps API  
- **Payment Processing**: mercadopago payment integration  

---

## Installation  

### Prerequisites  
- Flutter SDK (latest version)  
- Android Studio / VS Code  
- Firebase account  

### Steps  
1. Clone the repository:  
   ```bash
   git clone https://github.com/yourusername/alkilate.git
   cd alkilate
   ```

2. Install dependencies:  
   ```bash
   flutter pub get
   ```

3. Configure Firebase:  
   - Create a new Firebase project  
   - Add Android API keys to your project:
     - `android/app/src/main/AndroidManifest.xml`
   - Download and add configuration files:  
     - `google-services.json` (Android)  

4. Run the app:  
   ```bash
   flutter run
   ```

---

## Usage  

### For Renters  
1. Register/Login to your account  
2. Browse available rental items  
3. Check item availability via the calendar  
4. Select dates and create an order  
5. Complete checkout via mercadopago
6. Collect and return items as scheduled  

### For Owners  
1. Register/Login to your account  
2. List items with photos and descriptions  
3. Set availability dates and pricing  
4. Manage rental requests and track income  

---

## Project Structure  
```plaintext
lib/
├── main.dart          # Entry point
├── views/             # UI screens and widgets
├── services/          # Backend services
└── shared/            # Shared components
```
# Alkilate API Documentation  
**Built with Firebase Cloud Functions**  

---

## Base URL  
**Deployed Environment**  
```bash
https://[region]-[project-id].cloudfunctions.net/app
````
## Authentication
Most endpoints require a Firebase ID token in the header:
````http
Authorization: Bearer [your-firebase-id-token]
````

## Endpoints
### Test Endpoint
GET /
- Response:
````json
"Welcome to Alkilate API"
````

### Admin Endpoints
#### Get Pending Products
GET /admin
- Response:
````json
[
   { 
     "id": "pending-product", 
     "name": "Pending Product", 
     "approved": false, 
     "rejected": false 
   }
]
````

#### Approve Product
PUT /admin/accept
- Request Body:
````json
{ 
  "productId": "product-id", 
  "userId": "user-id" 
}
````
- Response:
````json
{ "message": "Product approved" }
````

#### Reject Product
PUT /admin/reject
- Request Body:
````json
{ 
  "productId": "product-id", 
  "userId": "user-id", 
  "message": "Reason for rejection" 
}
````
- Response:
````json
{ "message": "Product rejected" }
````

### Payment Endpoints
#### Create Checkout Session
POST /checkout
- Request Body:
````json
{ 
  "item": "Product Name", 
  "price": 1000, 
  "id": "order-id", 
  "user": "user-id", 
  "seller": "seller-id" 
}
````
- Response:
````text
"https://www.mercadopago.com.uy/checkout/v1/redirect?pref_id=..."
````
Process Payment Webhook

POST /checkout/payment
- Request Body:
````json
{ 
  "data": { 
    "id": "payment-id" 
  } 
}
````
- Response
````json
{ 
  "message": "Payment status checked successfully", 
  "data": { 
    "status": "approved", 
    "external_reference": "order-id|user-id|seller-id" 
  } 
}
````

## Error Handling
### HTTP Status Codes:

- `200`: Success

- `201`: Resource created

- `400`: Bad request (missing fields)

- `404`: Resource not found

- `500`: Server error

### Error Response Format:
````json
{ 
  "message": "Error message", 
  "error": "Detailed error information" 
}
````

# Alkilate Product Suggestions API

This project provides a Flask-based API for suggesting products based on a query. It uses the `sentence-transformers` library to encode product information and queries, and then finds the most similar products.

## Setup

1. Clone the repository from the IA-1.5 branch.
2. Install the required dependencies:
    ```bash
    pip install flask sentence-transformers requests numpy
    ```

## Running the API

To start the API, run the following command:
```bash
python app.py
```
The API will be available at `http://0.0.0.0:1000`.

## Endpoints

### POST /suggestions

This endpoint returns product suggestions based on a query.

#### Request

- **URL:** `/suggestions`
- **Method:** `POST`
- **Headers:** `Content-Type: application/json`
- **Body:**
    ```json
    {
        "query": "your search query"
    }
    ```

#### Response

- **Success Response:**
    - **Code:** 200
    - **Content:**
        ```json
        [
            {
                "name": "Product Name",
                "category": "Product Category",
                "description": "Product Description"
            },
            ...
        ]
        ```
- **Error Response:**
    - **Code:** 400
    - **Content:**
        ```json
        {
            "error": "No query provided"
        }
        ```

## How It Works

1. The API loads a pre-trained `sentence-transformers` model (`all-MiniLM-L6-v2`) when it starts.
2. It fetches product data from an external URL.
3. When a query is received, it encodes the product information and the query into vectors.
4. It calculates the cosine similarity between the query vector and the product vectors.
5. It returns the top 3 most similar products with a similarity score above a threshold.

## Dependencies

- Flask
- sentence-transformers
- requests
- numpy
