import 'dart:async';
import 'package:alkilate/services/models.dart' as app_models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alkilate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a single product document
  Future<app_models.Product> getProduct(String productId) async {
    var ref = _db.collection('Products').doc(productId);
    var snapshot = await ref.get();
    return app_models.Product.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a single product document
  Future<app_models.User> getUser(String userId) async {
    var ref = _db.collection('Users').doc(userId);
    var snapshot = await ref.get();
    return app_models.User.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a list of product documents
  Future<List<app_models.Product>> getProductList() {
    var ref = _db.collection('Products');
    return ref.get().then((snapshot) {
      return snapshot.docs
          .map((doc) => app_models.Product.fromJson(doc.data()))
          .toList();
    });
  }

  /// Posts a product document to the product db
  Future<void> postProduct(app_models.Product product) async {
    var user = AuthService().user!;
    var ref = _db.collection('Products').doc(user.uid);
    return ref.set(product.toJson());
  }

  /// Retrieves the current logged-in user's data from Firestore
  Future<app_models.User> getCurrentUser() async {
    // Get the current user from Firebase Auth
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Exception('No user is currently logged in.');
    }

    // Use the current user's UID to fetch their data from Firestore
    var ref = _db.collection('Users').doc(firebaseUser.uid);
    var snapshot = await ref.get();

    if (!snapshot.exists) {
      throw Exception('User data not found in Firestore.');
    }

    return app_models.User.fromJson(snapshot.data() ?? {});
  }

  /// Checks if a user document exists in Firestore, and creates one if it doesn't
  Future<void> checkAndCreateUserDocument(String uid) async {
    var userRef = _db.collection('Users').doc(uid);
    var snapshot = await userRef.get();

    if (!snapshot.exists) {
      // Create a new user document with default data
      await userRef.set({
        'uid': uid,
        'name': 'New User',
        'email': '',
        'dateCreated': DateTime.now().toIso8601String(),
        'isAdmin': false,
      });
    }
  }
}
