import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final DateTime dateCreated;
  final DateTime modifiedDate;
  String name;
  String email;
  String password;
  String phoneNumber;
  final String photoURL;
  final List<Comment> comments;
  final List<Product> products;
  final double rating;
  final bool isAdmin;

  User({
    this.uid = '',
    String? id,
    DateTime? dateCreated,
    DateTime? modifiedDate,
    this.name = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.photoURL = '',
    this.comments = const [],
    this.products = const [],
    this.rating = 0.0,
    this.isAdmin = false,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Product {
  final String id;
  final DateTime dateCreated;
  final DateTime modifiedDate;
  final String owner;
  final String name;
  final String description;
  final String brand;
  final String category;
  @JsonKey(fromJson: _latLngFromJson, toJson: _latLngToJson)
  final LatLng? location;
  final String geoHash;
  final double price;
  final String time;
  bool availability;
  final double rating;
  final double deposit;
  final bool approved;
  final bool rejected;
  final String message;
  final DateTime disponibleFrom;
  final DateTime disponibleTo;
  final List<DateTime> unavailableDates;
  final List<Map<String, dynamic>> comments;
  final List<String> pictures;
  final String bankAccount;
  final List<String> availableDates;

  Product({
    String? id,
    DateTime? dateCreated,
    DateTime? modifiedDate,
    DateTime? disponibleFrom,
    DateTime? disponibleTo,
    this.owner = '',
    this.name = '',
    this.description = '',
    this.brand = '',
    this.category = '',
    this.location,
    this.geoHash = '',
    this.price = 0.0,
    this.time = '',
    this.availability = false,
    this.unavailableDates = const [],
    this.deposit = 0.0,
    this.rating = 5.0,
    this.approved = false,
    this.rejected = false,
    this.message = '',
    this.comments = const [],
    this.pictures = const [
      'https://firebasestorage.googleapis.com/v0/b/alkilate-a4fbc.firebasestorage.app/o/images.jpg?alt=media&token=b7a596a5-3663-4bd9-a542-396e7367641e',
    ],
    this.bankAccount = '',
    this.availableDates = const [],
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now(),
        id = id ?? Uuid().v4(),
        disponibleFrom = dateCreated ?? DateTime.now(),
        disponibleTo = dateCreated ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  static LatLng? _latLngFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return LatLng(json['lat'], json['lng']);
  }

  // Helper function to convert LatLng to JSON
  static Map<String, dynamic>? _latLngToJson(LatLng? location) {
    if (location == null) return null;
    return {'lat': location.latitude, 'lng': location.longitude};
  }
}

@JsonSerializable()
class Order {
  final String id;
  final DateTime fromDate;
  final DateTime untilDate;
  final String buyer;
  final String seller;
  final String product;
  final String productId;
  final double totalPrice;
  final String status;
  final String productImage;

  Order({
    String? id,
    DateTime? fromDate,
    DateTime? untilDate,
    this.buyer = '',
    this.seller = '',
    this.product = '',
    this.productId = '',
    this.productImage = '',
    this.totalPrice = 0.0,
    this.status = '',
  })  : fromDate = fromDate ?? DateTime.now(),
        untilDate = untilDate ?? DateTime.now(),
        id = id ?? Uuid().v4();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class Comment {
  final String id;
  final DateTime dateCreated;
  final DateTime modifiedDate;
  final String user;
  final String product;
  final String text;
  final double rating;

  Comment({
    String? id,
    DateTime? dateCreated,
    DateTime? modifiedDate,
    this.user = '',
    this.product = '',
    this.text = '',
    this.rating = 0.0,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now(),
        id = id ?? Uuid().v4();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
