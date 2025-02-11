const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors");
const express = require("express");
const app = express();
const serviceAccount = require("./credentials.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://alkilate-a4fbc-default-rtdb.firebaseio.com",
});

const db = admin.firestore();
app.use(cors({origin: true}));

// Utility function to handle errors
const handleError = (res, error, message = "Internal server error") => {
  logger.error(message, error);
  return res.status(500).json({message, error: error.message});
};

// Routes

// Test route
app.get("/", (req, res) => {
  return res.status(200).send("Welcome to Alkilate API");
});

// Products routes

// Get a Single Product
app.get("/products/:id", async (req, res) => {
  try {
    const document = db.collection("products").doc(req.params.id);
    const product = await document.get();
    if (!product.exists) {
      return res.status(404).json({message: "Product not found"});
    }
    return res.status(200).json(product.data());
  } catch (error) {
    return handleError(res, error, "Error fetching product");
  }
});

// Get all products
app.get("/products", async (req, res) => {
  try {
    let query = db.collection("products");

    // List of allowed query parameters
    const allowedFilters = ["name", "category", "availability"];

    // Dynamically add filters to the query
    allowedFilters.forEach((filter) => {
      if (req.query[filter]) {
        query = query.where(filter, "==", req.query[filter]);
      }
    });

    // Handle price range separately
    if (req.query.priceMin || req.query.priceMax) {
      const priceMin = parseFloat(req.query.priceMin);
      const priceMax = parseFloat(req.query.price_max);

      if (!isNaN(priceMin)) {
        query = query.where("price", ">=", priceMin);
      }
      if (!isNaN(priceMax)) {
        query = query.where("price", "<=", priceMax);
      }
    }

    const querySnapshot = await query.get();
    const response = querySnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    if (response.length === 0) {
      logger.info("No products found matching the criteria.");
      return res.status(404).json({message: "No products found."});
    }

    logger.info("Products fetched successfully.");
    return res.status(200).json(response);
  } catch (error) {
    return handleError(res, error, "Error fetching products");
  }
});

// Post a product
app.post("/products", async (req, res) => {
  try {
    const productData = req.body;

    // Basic validation
    if (!productData.id || !productData.name || !productData.price) {
      return res.status(400).json({message: "Missing required fields"});
    }

    await db.collection("products").doc(`/${
      productData.id
    }/`).create(productData);
    return res.status(201).json({
      message: "Product created",
      id: productData.id,
    });
  } catch (error) {
    return handleError(res, error, "Error creating product");
  }
});

// Export the API to Firebase Cloud Functions
exports.app = functions.https.onRequest(app);
