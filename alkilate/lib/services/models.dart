import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class User {
  final String id;
  final DateTime dateCreated;
  final DateTime modifiedDate;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String photoURL;
  final List<Comment> comments;
  final List<Product> products;
  final double rating;
  final bool isAdmin;

  User({
    this.id = '',
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
  final String brand;
  final String category;
  final String location;
  final double price;
  final bool availability;
  final double deposit;
  final bool approved;
  final List<Map<String, dynamic>> comments;
  final List<String> pictures;
  final String bankAccount;

  Product({
    this.id = '',
    DateTime? dateCreated,
    DateTime? modifiedDate,
    this.owner = '',
    this.name = '',
    this.brand = '',
    this.category = '',
    this.location = '',
    this.price = 0.0,
    this.availability = false,
    this.deposit = 0.0,
    this.approved = false,
    this.comments = const [],
    this.pictures = const [],
    this.bankAccount = '',
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Order {
  final String id;
  final DateTime dateCreated;
  final DateTime modifiedDate;
  final String buyer;
  final String seller;
  final String product;
  final double totalPrice;
  final String status;

  Order({
    this.id = '',
    DateTime? dateCreated,
    DateTime? modifiedDate,
    this.buyer = '',
    this.seller = '',
    this.product = '',
    this.totalPrice = 0.0,
    this.status = '',
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

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
    this.id = '',
    DateTime? dateCreated,
    DateTime? modifiedDate,
    this.user = '',
    this.product = '',
    this.text = '',
    this.rating = 0.0,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
