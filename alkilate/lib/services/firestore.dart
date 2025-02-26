import 'dart:async';
import 'package:alkilate/services/models.dart' as app_models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a single product document
  Future<app_models.Product> getProduct(String productId) async {
    var ref = _db.collection('products').doc(productId);
    var snapshot = await ref.get();
    return app_models.Product.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a single user document
  Future<app_models.User> getUser(String userId) async {
    var ref = _db.collection('Users').doc(userId);
    var snapshot = await ref.get();
    return app_models.User.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a list of order documents for a user
  Future<List<app_models.Order>> getOrderList() {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('orders');
    return ref.get().then((snapshot) {
      return snapshot.docs
          .map((doc) => app_models.Order.fromJson(doc.data()))
          .toList();
    });
  }

  /// Retrieves a list of product documents for a user
  Future<List<app_models.Product>> getUserProductsList() {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('products');
    return ref.get().then((snapshot) {
      return snapshot.docs
          .map((doc) => app_models.Product.fromJson(doc.data()))
          .toList();
    });
  }

  ///Delete a product
  Future<void> deleteProduct(String productId) async {
    var ref = _db.collection('products').doc(productId);
    await ref.delete();
    ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('products')
        .doc(productId);
    await ref.delete();
    return;
  }

  ///Update the availability of a product to the oposite bool
  Future<void> toggleProductAvailability(String productId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Get references to the documents
      final productRef = firestore.collection('products').doc(productId);
      final userRef = firestore
          .collection('Users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .collection('products')
          .doc(productId);

      // Fetch both documents
      final productSnapshot = await productRef.get();
      final userSnapshot = await userRef.get();

      if (!productSnapshot.exists || !userSnapshot.exists) {
        throw Exception('Product or user product document does not exist');
      }

      // Get current availability
      final bool currentProductAvailability =
          productSnapshot.data()?['availability'] ?? false;
      final bool currentUserProductAvailability =
          userSnapshot.data()?['availability'] ?? false;

      // Ensure both documents have the same availability value
      if (currentProductAvailability != currentUserProductAvailability) {
        throw Exception('Product availability mismatch between collections');
      }

      // Toggle availability
      final bool newAvailability = !currentProductAvailability;

      // Use a batch to update both documents atomically
      final batch = firestore.batch();
      batch.update(productRef, {'availability': newAvailability});
      batch.update(userRef, {'availability': newAvailability});

      // Commit the batch
      await batch.commit();

      print('Product availability toggled successfully: $newAvailability');
    } catch (e) {
      print('Error toggling product availability: $e');
      rethrow; // Re-throw the error for the caller to handle
    }
  }

  Future<List<app_models.Product>> getProductList() async {
    var ref = _db.collection('products');

    // Fetch the documents from the collection
    var snapshot = await ref.get();

    // Filter documents where 'approved' is true
    var approvedProducts = snapshot.docs
        .where((doc) =>
            doc.data()['approved'] == true) // Filter by 'approved' field
        .map((doc) =>
            app_models.Product.fromJson(doc.data())) // Map to Product model
        .toList(); // Convert to List

    return approvedProducts;
  }

  /// Posts a product document to the product db
  Future<void> postProduct(app_models.Product product) async {
    var ref = _db.collection('products').doc(product.id);
    await ref.set(product.toJson());
    return;
  }

  Future<void> updateUserData(app_models.User user) async {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid);
    await ref.set(user.toJson());
    return;
  }

  /// Add a product document to the user's products db
  Future<void> addProductToUser(app_models.Product product) async {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('products')
        .doc(product.id);
    await ref.set(product.toJson());
    return;
  }

  /// Adds an order document to the user's orders db
  Future<void> addOrderToUser(app_models.Order order) async {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(order.id);
    await ref.set(order.toJson());
    return;
  }

  /// Adds an order document to the seller db
  Future<void> addOrderToSeller(app_models.Order order) async {
    print(order.seller);
    var ref = _db
        .collection('Users')
        .doc(order.seller)
        .collection('listings')
        .doc(order.id);
    await ref.set(order.toJson());
    return;
  }

  Future<List<app_models.Order>> getListings() async {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('listings');
    var snapshot = await ref.get();
    var orders = snapshot.docs
        .where((doc) =>
            doc.data()['status'] == 'approved') // Filter by 'approved' field
        .map((doc) =>
            app_models.Order.fromJson(doc.data())) // Map to Product model
        .toList();
    return orders;
  }

  /// Cancel an order document
  Future<void> cancelOrder(String orderId) async {
    var ref = _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('orders')
        .doc(orderId);
    await ref.delete();
    var ref2 = _db.collection('orders').doc(orderId);
    await ref2.delete();
    return;
  }

  ///seller accepts order
  Future<void> acceptOrder(String orderId, String buyerId) async {
    await _db
        .collection('Users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid)
        .collection('listings')
        .doc(orderId)
        .update({'status': 'accepted'});
    await _db.collection('orders').doc(orderId).update({'status': 'accepted'});
    await _db
        .collection('Users')
        .doc(buyerId)
        .collection('orders')
        .doc(orderId)
        .update({'status': 'accepted'});
    return;
  }

  /// Adds an order document to the orders db
  Future<void> addOrder(app_models.Order order) async {
    var ref = _db.collection('orders').doc(order.id);
    await ref.set(order.toJson());
    return;
  }

  /// Retrieves the current logged-in user's data from Firestore
  Future<app_models.User> getCurrentUser() async {
    // Get the current user from Firebase Auth
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

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

  /// add a comment to a product
  Future<void> addCommentToProduct(app_models.Comment comment) async {
    var ref = _db
        .collection('products')
        .doc(comment.product)
        .collection('comments')
        .doc(comment.id);
    await ref.set(comment.toJson());
    return;
  }

  /// get comments for a product
  Stream<List<app_models.Comment>> getCommentsForProduct(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => app_models.Comment.fromJson(doc.data()))
            .toList());
  }

  /// Checks if a user document exists in Firestore, and creates one if it doesn't
  Future<void> checkAndCreateUserDocument(String uid) async {
    var userRef = _db.collection('Users').doc(uid);
    var snapshot = await userRef.get();
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;

    if (!snapshot.exists) {
      // Create a new user document with default data
      await userRef.set({
        'uid': uid,
        'name': firebaseUser!.displayName,
        'email': firebaseUser.email,
        'photoURL': firebaseUser.photoURL,
        'phoneNumber': firebaseUser.phoneNumber,
        'dateCreated': DateTime.now().toIso8601String(),
        'isAdmin': false,
      });
    }
  }
}
