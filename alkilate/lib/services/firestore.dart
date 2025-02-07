import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
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

  /// Retrieves a list of product documents from the user posts
  Stream<Product> streamProduct() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('Products').doc(user.uid);
        return ref.snapshots().map((doc) => Product.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Product()]);
      }
    });
  }

  /// Retrives user data for loged in user
  Stream<User> streamUser() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('Users').doc(user.uid);
        return ref.snapshots().map((doc) => User.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([User()]);
      }
    });
  }

  /// Posts a product document to the product db
  Future<void> postProduct(Product product) async {
    var user = AuthService().user!;
    var ref = _db.collection('Products').doc(user.uid);
    return ref.set(product.toJson());
  }
}
