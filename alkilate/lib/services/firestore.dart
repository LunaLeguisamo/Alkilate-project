import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alkilate/services/auth.dart';
import 'package:alkilate/services/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a single product document
  Future<Product> getProduct(String productId) async {
    var ref = _db.collection('Products').doc(productId);
    var snapshot = await ref.get();
    return Product.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a single product document
  Future<User> getUser(String userId) async {
    var ref = _db.collection('Users').doc(userId);
    var snapshot = await ref.get();
    return User.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a list of product documents
  Future<List<Product>> getProductList() {
    var ref = _db.collection('Products');
    return ref.get().then((snapshot) {
      return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    });
  }

  /// Posts a product document to the product db
  Future<void> postProduct(Product product) async {
    var user = AuthService().user!;
    var ref = _db.collection('Products').doc(user.uid);
    return ref.set(product.toJson());
  }
}
